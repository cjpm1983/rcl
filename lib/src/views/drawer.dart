import 'package:blocs_sample/src/controllers/listado_page_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blocs_sample/src/controllers/drawer_controller.dart';

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
                      title: 'Acerca de',
                      //middleText: 'para poner contador a 0',
                      content: Column(
                                        children: [
                                          Text("Contenido"),
                                          Text("Contenido"),
                                        ]
                          
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
