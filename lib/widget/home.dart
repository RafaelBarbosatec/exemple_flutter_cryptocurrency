import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../conection/api.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List _currencies = new List();

  int page = 0;

  bool carregando = false;

  CryptoApi repository = new CryptoApi();

  void _NextPage(int page) async {

    setState((){

      this.page++;
      carregando = true;

    });

    List c = await repository.loadCrypto(page,20);

    if(_currencies != null) {

      setState(() {

        _currencies.addAll(c);
        carregando = false;

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    if(page == 0){
      _NextPage(page);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[_buildProgress()],
      ),
      body: _buildBody(),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildProgress(){

    return carregando ? new Container(
        margin: new EdgeInsets.all(5.0),
        padding: new EdgeInsets.all(5.0),
        child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),)
    ) : new Container();

  }

  Widget _buildBody(){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
          _getListViewWidget()
        ],
      ),
    );
  }

  Widget _getListViewWidget(){

    ListView listView = new ListView.builder(
        itemCount: _currencies.length,
        itemBuilder: (context, index){

          final Map currency = _currencies[index];

          if(_currencies.length != null)
            if(index > _currencies.length -5 && !carregando){

              _NextPage(page);
            }

          return _getListItemWidget(currency);
        });

    RefreshIndicator refreshIndicator = new RefreshIndicator(
        onRefresh: onRefresh,
        child: listView
    );

    return new Flexible(
        child: refreshIndicator
    );

  }

  Future onRefresh() async {
    setState((){
      _currencies.clear();
      page = 0;
    });

    _NextPage(page);

    return true;
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