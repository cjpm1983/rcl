import 'dart:convert';

import "package:flutter/services.dart" show rootBundle;
import 'package:get_storage/get_storage.dart';


class _SongsProvider{

  GetStorage songstorage = GetStorage('songs');


  List<dynamic> canciones = [];

  _SongsProvider(){
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{


      if (songstorage.read('canciones') == null){
        final resp = await rootBundle.loadString('data/alaba.json');
        Map dataMap = json.decode(resp);
        //print(dataMap['canciones']);
        
        List<dynamic> cancionesT = dataMap['canciones'];
        
        canciones = cancionesT.map((c){
          c["favorito"]=false;
          //c.favorito=false;
          return c;
        }
        ).toList();

        songstorage.write('canciones',canciones);
      }

      canciones = songstorage.read('canciones');

      print(canciones);
      return canciones;

  }

  void guardarCanciones(List cancionesAct) {
    songstorage.write('canciones',cancionesAct);
  }

}

final songsProvider = new _SongsProvider();