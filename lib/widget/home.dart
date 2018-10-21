
import 'package:crypto_market_cap/support/BlocProvider.dart';
import 'package:crypto_market_cap/widget/homeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class HomePage extends StatelessWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  static Widget create(){

    return BlocProvider<HomeBloc>(
      bloc: HomeBloc(),
      child: HomePage(title: "Bloc",),
    );

  }

  @override
  Widget build(BuildContext context) {

    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    bloc.myRefresh();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[_buildProgress(bloc)],
      ),
      body: _buildBody(bloc),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildProgress(HomeBloc bloc){

    return StreamBuilder<bool>(
      stream: bloc.progressController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        return (snapshot?.data ?? false) ? new Container(
            margin: new EdgeInsets.all(5.0),
            padding: new EdgeInsets.all(5.0),
            child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)
        ) : new Container();
      },
    );

  }

  Widget _buildBody(HomeBloc bloc){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
          _getListViewWidget(bloc)
        ],
      ),
    );
  }

  Widget _getListViewWidget(HomeBloc bloc){

    return Flexible(
      child: StreamBuilder<List>(
        stream: bloc.listController.stream,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot){

          return RefreshIndicator(
              onRefresh: bloc.myRefresh,
              child: ListView.builder(
                  itemCount: snapshot?.data?.length ?? 00,
                  itemBuilder: (context, index){

                    final Map currency = snapshot.data[index];

                    if(snapshot.data.length != null)
                      if(index > snapshot.data.length -5){
                        bloc.nextPage();
                      }

                    return _getListItemWidget(currency);

                  })
          );
        },
      ),
    );

  }

  Widget _getListItemWidget(currency){

    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency),
      ),
    );
  }

  ListTile _getListTile(Map currency){

    return new ListTile(
      leading: _getLeadingWidget(currency['name'],currency['symbol']),
      title: _getTittleWidget(currency['name']),
      subtitle: _getSubtitleWidget(currency['price_usd']),
      trailing: _getTrailingWidget(currency['percent_change_24h']),
      onTap: onTapTile(),
    );

  }

  onTapTile(){


  }

  CircleAvatar _getLeadingWidget(String currencyName,String symbol){

    return new CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: _getImageNetwork(symbol),
      //child: new Text(currencyName[0]),
    );
  }

  Object _getImageNetwork(symbol){

    var imageUrl = "https://res.cloudinary.com/dxi90ksom/image/upload/$symbol";

    try{
      return new NetworkImage(imageUrl);
    }catch(e){
      return new Text("EMPTY");
    }

  }

  Text _getTittleWidget(String curencyName){
    return new Text(
      curencyName,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Text _getSubtitleWidget(String priceUsd){

    return new Text('R\$ $priceUsd');

  }

  Widget _getTrailingWidget(String percentChange1h){

    return new Column(
      children: <Widget>[
        _getTextPeriodoTrailig(),
        _getTextPorcentTrailing(percentChange1h)],
    );

  }

  Widget _getTextPeriodoTrailig(){

    return new Text("24h",
      style: new TextStyle(
          fontSize: 8.0
      ),
    );

  }

  Widget _getTextPorcentTrailing(String percentChange1h){

    var percent = double.parse(percentChange1h);

    return new Text(
      '$percentChange1h%',
      style: new TextStyle(
          color: (percent > 0) ?  Colors.green : Colors.red
      ),
    );
  }
}