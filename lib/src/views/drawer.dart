import 'package:alaba/src/controllers/drawer_controller.dart';
import 'package:alaba/src/controllers/listado_page_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_linkify/flutter_linkify.dart';


class DrawerWidget extends GetView<DrawerX> {
  @override
  Widget build(BuildContext context) {
    DrawerX dd = Get.put(DrawerX());
    ListDataX dx = Get.put(ListDataX());
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/trigo.jpg')),
              color: Colors.blue,
            ),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Row(
            //       children: [
            //         IconButton(
            //           icon: Icon(Icons.arrow_back),
            //           onPressed: ()=>Navigator.pop(context),
            //         ),
            //         Text('Ajustes Personalizados'),

            //       ],
            //     ),
            //   ],
            // ),
          ),
          ListTile(
            //tileColor: Colors.grey[300],
            title: Center(
                child: Text(
              'Ajustes',
              textScaleFactor: 1.5,
            )),
            trailing: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              'Mostrar solo favoritos',
              style: _textoItemDrawer(),
            ),
            leading: Icon(Icons.star, color: Colors.blue),
            onTap: () {
              //Para cerrar
              dx.changesolofav(true);
              dx.consulta(" ");
              dx.consulta("");
              Navigator.pop(context);
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading:
                Icon(Icons.my_library_music_rounded, color: Colors.grey[400]),
            title: Text(
              'Mostrar Todo',
              style: _textoItemDrawer(),
            ),
            onTap: () {
              dx.changesolofav(false);
              dx.consulta(" ");
              dx.consulta("");
              Navigator.pop(context);
            },
          ),
          Divider(),

          Obx(() => ListTile(
                title: dd.modoOscuro
                    ? Text('Modo oscuro', style: _textoItemDrawer(), )
                    : Text('Modo claro', style: _textoItemDrawer(),),
                
                leading: dd.modoOscuro
                    ? Icon(Icons.nights_stay)
                    : Icon(Icons.brightness_high_sharp),
                    

                onTap: () {
                  dd.modoOscuro = !dd.modoOscuro;
                  Get.changeTheme(
                          ThemeData(
                            brightness: dd.modoOscuro ? Brightness.light : Brightness.dark,
                          ),
                    );
                  
                },
              )),
              ListTile(
                title: Text("Acerca de", style: _textoItemDrawer() ),
                leading:  Icon(Icons.message), 
                onTap:  (){
                      
                      Navigator.pop(context);

                      Get.defaultDialog(
                      title: '\nAcerca de',
                      //middleText: 'para poner contador a 0',
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        child: Column(
                                          children: [
                                            Divider(),
                                            Text("Alaba version 1.0"),
                                            Divider(),
                                            Text("Para mi madre Juana Luisa Morales",style: TextStyle(fontStyle: FontStyle.italic),),
                                            Divider(),
                                            Text("Desarrollador: Carlos J. Palacios"),
                                            Text("Compilación de himnos y canciones: Olga M. Palacios y Juana L. Morales"),
                                            SelectableLinkify(
                                                  text: "Contacto: cjpm1983@gmail.com",
                                                ),
                                            
                                            Divider(color: Colors.yellow),
                                            Text("¡Que todo lo que respira cante alabanzas al Señor!¡Alabado sea el Señor!\nSalmo 150:6",style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green[600]),),
                                          ]
                            
                        ),
                      ),
                      textConfirm: 'Cerrar',
                      onConfirm: (){
                        Get.back();
                        }
                      );
                      
                      
                      }
            
                ,
              ),
        ],
      ),
    );
  }

  _textoItemDrawer() {
    return TextStyle(
      fontSize: 20,
    );
  }
}
