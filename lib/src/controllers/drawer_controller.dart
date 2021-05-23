import 'package:get/get.dart';

class DrawerX extends GetxController {
  var _modoOscuro = true.obs;

  set modoOscuro(bool modo){
    _modoOscuro.value = modo;
    print("Cambiado a $_modoOscuro");
  }

  get modoOscuro{
    return _modoOscuro.value;
  }




}