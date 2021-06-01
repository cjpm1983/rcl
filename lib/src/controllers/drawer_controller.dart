import 'dart:math';

import 'package:get/get.dart';
import 'package:alaba/src/providers/songs_provider.dart';

class DrawerX extends GetxController {
  var _modoOscuro = true.obs;
  var _random=1.obs;

  DrawerX(){
    randomize();
  }

  set modoOscuro(bool modo){
    _modoOscuro.value = modo;
    songsProvider.modoOscuro = modo;
    update();

    print("Cambiado a $modo");
  }

  get modoOscuro{
    _modoOscuro.value = songsProvider.modoOscuro;
    update();
    return _modoOscuro.value;
  }


  void randomize(){
    int min = 1;
    int max = 13;
    var random = new Random();
    _random.value = min+ random.nextInt(max-min) ;
    print("Random cambiado a $_random");

  }
  get random{
    print("SolicitadoRandom $_random");
    return _random;
  }




}