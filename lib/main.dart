import 'package:alaba/src/reproductor/controllers/download_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'src/controllers/drawer_controller.dart';
//import 'src/controllers/radio_player_controller.dart';
import 'src/views/radioPlayer.dart';

import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }
main() async {
  await GetStorage.init("param");
  await GetStorage.init("songs");
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);


    DrawerX dd = Get.put(DrawerX());
    
    DownloadX dw = Get.put(DownloadX());
    //RadioCX rx = Get.put(RadioCX());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RadioTM',
      theme: ThemeData(
        brightness: dd.modoOscuro ? Brightness.light : Brightness.dark,
        //primarySwatch: Colors.,
      ),
      home: RadioPlayer(),
    );
  }

}
