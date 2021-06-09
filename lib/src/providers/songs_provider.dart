import 'dart:convert';

//import "package:flutter/services.dart" show rootBundle;
import 'package:alaba/src/controllers/radio_player_controller.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:async';
import 'package:http/http.dart' as http;


class _SongsProvider{

  GetStorage songstorage = GetStorage('songs');


  List<dynamic> _emisoras = [];
  bool _modoOscuro = true;
  bool _background = false;
  
  //bool _modoAhorro = true;
  int _idEmisoraActual = 1;

  var _ahorro;

  _SongsProvider(){
    cargarData();
  }




  Future<List<dynamic>> cargarData()async{

      var response = await http.get("https://raw.githubusercontent.com/cjpm1983/db/main/rcl.json");
      //var response = await http.get("http://192.168.43.73/emisoras/urls.json");

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

  get background {
     if (songstorage.read('background') == null){
       songstorage.write('background',false);
     }
     _background =  songstorage.read('background');
    return _background;
  }

  set background(bool modo){
    _background = modo;
    songstorage.write('background',_background);
  }

  // get modoAhorro {
  //    if (songstorage.read('modoAhorro') == null){
  //      songstorage.write('modoAhorro',true);
  //    }
  //    _modoAhorro =  songstorage.read('modoAhorro');
  //   return _modoAhorro;
  // }

  // set modoAhorro(bool modo){
  //   _modoAhorro = modo;
  //   songstorage.write('modoAhorro',_modoAhorro);
  // }


  get ahorro{
    if (songstorage.read('ahorro') == null){
       songstorage.write('ahorro','e');
     }
     var valor =  songstorage.read('ahorro');
     switch (valor) {
       case 'd':
         _ahorro = Ahorros.desactivado;
         break;
       
       case 'm':
         _ahorro = Ahorros.moderado;
         break;
       
       case 'e':
         _ahorro = Ahorros.extremo;
         break;
       default:
       _ahorro = Ahorros.extremo;
     }
     
     return _ahorro;

  }

  set ahorro(Ahorros modo) {
//Lo llevamos a string porque enum no se puede almacenar en la base de datos
String valor = "";
    switch (modo) {
      case Ahorros.desactivado:
        valor = "d";
        break;
      case Ahorros.moderado:
        valor = "m";
        break;
      case Ahorros.extremo:
        valor = "e";
        break;
      default:
        valor = "e";
    }    
    _ahorro = valor;
    songstorage.write('ahorro',valor);
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