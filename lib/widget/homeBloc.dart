

import 'dart:async';

import 'package:crypto_market_cap/conection/api.dart';
import 'package:crypto_market_cap/support/BlocProvider.dart';

class HomeBloc implements BlocBase {

  List _currencies = new List();

  StreamController<List> listController = StreamController<List>();
  StreamController<bool> progressController = StreamController<bool>();

  int _page = 0;

  bool _carregando = false;

  CryptoApi repository = new CryptoApi();

  void _NextPage(int page) async {

    this._page++;
    _carregando = true;
    progressController.sink.add(_carregando);

    List c = await repository.loadCrypto(page,20);

    if(_currencies != null) {

        _currencies.addAll(c);
        listController.sink.add(_currencies);

        _carregando = false;
        progressController.sink.add(_carregando);

    }

  }

  nextPage(){

    if(!_carregando)
      _NextPage(_page);

  }

  Future<void> myRefresh() async {
    _page = 0;
    _currencies.clear();
    _NextPage(0);

    return;

  }

  @override
  void dispose() {
    progressController.close();
    listController.close();
  }

  @override
  void initState() {
    print("initState");
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
  }

}