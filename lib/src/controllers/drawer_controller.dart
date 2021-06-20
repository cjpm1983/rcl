
import 'package:get/get.dart';
import 'package:alaba/src/providers/songs_provider.dart';


class DrawerX extends GetxController {
  
  var _modoOscuro = true.obs;
 
  // DrawerX(){
  //   ;
  // }

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

}