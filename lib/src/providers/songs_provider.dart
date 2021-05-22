import 'dart:convert';

import "package:flutter/services.dart" show rootBundle;


class _SongsProvider{

  List<dynamic> canciones = [];

  _SongsProvider(){
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{

      final resp = await rootBundle.loadString('data/alaba.json');
      Map dataMap = json.decode(resp);
      //print(dataMap['canciones']);
      canciones = dataMap['canciones'];
      
      return canciones;

  }

}

final songsProvider = new _SongsProvider();