import 'dart:convert';

//import "package:flutter/services.dart" show rootBundle;
import 'package:get_storage/get_storage.dart';

import 'dart:async';
import 'package:http/http.dart' as http;


class _SongsProvider{

  GetStorage songstorage = GetStorage('songs');


  List<dynamic> _emisoras = [];
  bool _modoOscuro = true;
  bool _modoAhorro = true;
  int _idEmisoraActual = 1;

  _SongsProvider(){
    cargarData();
  }


  Future<List<dynamic>> cargarData()async{

      var response = await http.get("http://192.168.43.73/emisoras/urls.json");

      if (response.statusCode == 200){

        //List<dynamic> values = [];
        //print (response.body);
        Map dataMap = json.decode(response.body);

        

        List<dynamic> emisorasT = dataMap['emisoras'];

        _emisoras = emisorasT.map((c)=>c).toList();

      }
       
      return _emisoras;

  }

  void guardarCanciones(List cancionesN) {
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

  get modoAhorro {
     if (songstorage.read('modoAhorro') == null){
       songstorage.write('modoAhorro',true);
     }
     _modoAhorro =  songstorage.read('modoAhorro');
    return _modoAhorro;
  }

  set modoAhorro(bool modo){
    _modoAhorro = modo;
    songstorage.write('modoAhorro',_modoAhorro);
  }

  get idEmisoraActual{
     if (songstorage.read('idEmisoraActual') == null){
       songstorage.write('idEmisoraActual',1);
     }
     _idEmisoraActual =  songstorage.read('idEmisoraActual');
    return _idEmisoraActual;
  }

  set idEmisoraActual(int emisora){
    _idEmisoraActual = emisora;
    songstorage.write('idEmisoraActual',_idEmisoraActual);
  }

}

final songsProvider = new _SongsProvider();