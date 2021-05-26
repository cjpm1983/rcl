import 'dart:math';

import 'package:get/get.dart';
import 'package:alaba/src/providers/songs_provider.dart';

class DrawerX extends GetxController {
  var _modoOscuro = true.obs;

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

  int random() {
    int min = 1;
    int max = 13;
    return min+( Random(1).nextInt(max-min) );
  }




}