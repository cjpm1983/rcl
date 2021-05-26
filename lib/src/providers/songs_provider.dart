import 'dart:convert';

import "package:flutter/services.dart" show rootBundle;
import 'package:get_storage/get_storage.dart';


class _SongsProvider{

  GetStorage songstorage = GetStorage('songs');


  //List<dynamic> canciones = [];
  bool _modoOscuro = true;

  _SongsProvider(){
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{

      List<dynamic> canciones = [];

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
        //songstorage.write('modoOscuro',_modoOscuro);

      }

      canciones = songstorage.read('canciones');
      //_modoOscuro = songstorage.read('modoOscuro');

      print("Cargadas las canciones del song provider");
      return canciones;

  }

  void guardarCanciones(List cancionesN) {
    //canciones = cancionesN;
    songstorage.write('canciones',cancionesN);
  }

  get modoOscuro {
     if (songstorage.read('modoOscuro') == null){
       songstorage.write('modoOscuro',true);
     }
     _modoOscuro =  songstorage.read('modoOscuro');
    return _modoOscuro;
  }

  set modoOscuro(bool modo){
    _modoOscuro = modo;
    songstorage.write('modoOscuro',_modoOscuro);
  }

}

final songsProvider = new _SongsProvider();