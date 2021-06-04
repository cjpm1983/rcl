import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import 'src/controllers/drawer_controller.dart';
import 'src/controllers/radio_player_controller.dart';
import 'src/views/radioPlayer.dart';

// void main() {
//   runApp(MyApp());
// }
main() async {
  await GetStorage.init("param");
  await GetStorage.init("songs");
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DrawerX dd = Get.put(DrawerX());
    //RadioCX rx = Get.put(RadioCX());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RadioTM',
      theme: ThemeData(
        brightness: dd.modoOscuro ? Brightness.light : Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: RadioPlayer(),
    );
  }

}
