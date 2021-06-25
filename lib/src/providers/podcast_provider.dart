import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import 'dart:async';
import 'package:http/http.dart' as http;


class _PodcastsProvider{

  GetStorage Podcaststorage = GetStorage('Podcasts');


  List<dynamic> _podcasts = [];
  
  //bool _modoAhorro = true;
  int _idpodcastActual = 1;
  bool _offline = false;
  var _aviso;

  _PodcastsProvider(){
    cargarData();
  }

  Future<List<dynamic>> cargarData()async{

      var response = await http.get("https://raw.githubusercontent.com/cjpm1983/db/main/prcl.json");

      if (response.statusCode == 200){

        Map dataMap = json.decode(response.body);

        

        List<dynamic> podcastsT = dataMap['podcasts'];

        _podcasts = podcastsT.map((c)=>c).toList();

        _aviso = dataMap['aviso'];
        //print("En el provider aviso es $_aviso");

      }
      // print(_podcasts);
      return _podcasts;

  }

  void guardarPodcasts(List podcastsN) {
    Podcaststorage.write('podcasts',podcastsN);
  }



  get aviso {
    return _aviso;
  }

}

final PodcastsProvider = new _PodcastsProvider();