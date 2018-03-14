import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoApi{

  final String url = 'https://api.coinmarketcap.com/v1/ticker/';

  Future <List> loadCrypto(int page,int limit) async{

    page = page*limit;

    String apiUrl = '$url?convert=BRL&start=$page&limit=$limit';
    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(apiUrl);
    // Using the JSON class to decode the JSON String
    return JSON.decode(response.body);

  }
}