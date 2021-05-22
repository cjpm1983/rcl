import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blocs_sample/src/controllers/inicio_page_controller.dart';

import 'aboutPage.dart';
import 'drawer.dart';
import 'listadoPage.dart';

class InicioPage extends StatelessWidget {
  String title = "Inicio";

  final InicioPageController controller = Get.put(InicioPageController());

  InicioPage({this.title = "Inicio"});

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
              onPressed: ()=>Get.to(AboutPage()), 
              child: Text("Acerca de")
            ),
            Obx( () => Text("Presionaste ${controller.count.value}")) ,
            TextButton(
              onPressed: ()=>Get.to(ListadoPage()), 
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
        onPressed: ()=> controller.increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
