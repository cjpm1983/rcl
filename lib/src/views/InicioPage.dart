import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alaba/src/controllers/inicio_page_controller.dart';

import 'aboutPage.dart';
import 'drawer.dart';
import 'listadoPage.dart';

class InicioPage extends StatelessWidget {
  final String title = "Himnos y Canciones";

  final InicioPageController controller = Get.put(InicioPageController());

  InicioPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx( () => Text("Presionaste ${controller.count.value}")) ,
            TextButton(
              onPressed: ()=>Get.to(()=>AboutPage()), 
              child: Text("Acerca de")
            ),
            Obx( () => Text("Presionaste ${controller.count.value}")) ,
            TextButton(
              onPressed: ()=>Get.to(()=>ListadoPage()), 
              child: Text("Listado")
            ),
            IconButton(icon: Icon(Icons.message), 
            onPressed: ()=> Get.defaultDialog(
                      title: 'GetX Alert',
                      middleText: 'para poner contador a 0',
                      textConfirm: 'Aceptar',
                      confirmTextColor: Colors.white,
                      textCancel: 'Cancelar',
                      onConfirm: (){
                        controller.inicializar();
                        Get.back();
                        }
                      )
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          controller.increment();
                              Get.changeTheme(ThemeData(
                            brightness: Brightness.dark,
                            primarySwatch: Colors.blue,
                          ),);
                    Get.changeThemeMode(ThemeMode.dark);
          },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
