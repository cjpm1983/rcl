//import 'dart:html';

import 'package:alaba/src/controllers/drawer_controller.dart';
import 'package:alaba/src/controllers/radio_player_controller.dart';
//import 'package:custom_timer/custom_timer.dart';
// import 'package:alaba/src/controllers/listado_page_controler.dart';
// import 'package:alaba/src/controllers/radio_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_linkify/flutter_linkify.dart';



class DrawerWidget extends GetView<DrawerX> {
  @override
  Widget build(BuildContext context) {
    DrawerX dd = Get.put(DrawerX());
    RadioCX rx = Get.put(RadioCX());   
   
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.only(top:24),
        children: <Widget>[
          //Divider(height: 24,),
           DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  title: Text("Radio Trans Mundial "),
                 
                  
                ),
              ],
            ),
            decoration: BoxDecoration(
              image:  DecorationImage(
                                fit: BoxFit.fill, image: AssetImage('assets/rtm.png')),
              color: Colors.blue,
            ),

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
            title: Text("Emisora", style: _textoItemDrawer()),
            leading: Icon(Icons.radio_rounded),
          ),
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
                title: Text("Autoapagado", style: _textoItemDrawer() ),
                leading:  Icon(Icons.av_timer_rounded), 
                onTap:  (){
                      
                      Navigator.pop(context);

                      Get.defaultDialog(
                      title: '\nAutoapagado',
                      //middleText: 'para poner contador a 0',
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        child: Column(
                                          children: [
                                            
                                            Text("Para evitar el drenado de datos la emisora se apagará en el tiempo seleccionado aquí"),
                                            Divider(color: Colors.yellow),
                                            Obx(()=>
                                              Column(
                                                children: [
                                                    RadioListTile<Tempos>(
                                                            title: const Text('1 hora.'),
                                                            value: Tempos.h1,
                                                            groupValue: rx.tempo,
                                                            onChanged: (Tempos value) {
                                                              rx.tempo = value; 
                                                            },
                                                          ),
                                                      
                                                    RadioListTile<Tempos>(
                                                        title: const Text('30 minutos.'),
                                                        value: Tempos.m30,
                                                        groupValue: rx.tempo,
                                                        onChanged: (Tempos value) {
                                                          rx.tempo = value; 
                                                        },
                                                      ),
                                                    RadioListTile<Tempos>(
                                                        title: const Text('15 minutos.'),
                                                        value: Tempos.m15,
                                                        groupValue: rx.tempo,
                                                        onChanged: (Tempos value) {
                                                          rx.tempo = value; 
                                                        },
                                                      ),
                                                    RadioListTile<Tempos>(
                                                        title: const Text('5 minutos.'),
                                                        value: Tempos.m5,
                                                        groupValue: rx.tempo,
                                                        onChanged: (Tempos value) {
                                                          rx.tempo = value; 
                                                        },
                                                      ),
                                                ],
                                              ),
                                            )
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
 
             
              
              ListTile(
                title: Text("Acerca de", style: _textoItemDrawer() ),
                leading:  Icon(Icons.info_outline), 
                onTap:  (){
                      
                      Navigator.pop(context);

                      // Get.defaultDialog(
                      // title: '\nAcerca de',
                      // //middleText: 'para poner contador a 0',
                      // content: Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      //   child: Column(
                      //                     children: [
                                            
                      //                       Text("Alaba version 1.0"),
                      //                       Divider(),
                      //                       Text("Para mi madre Juana Luisa Morales",style: TextStyle(fontStyle: FontStyle.italic),),
                      //                       Divider(),
                      //                       Text("Desarrollador: Carlos J. Palacios"),
                      //                       Text("Compilación de himnos y canciones: Olga M. Palacios y Juana L. Morales"),
                      //                       SelectableLinkify(
                      //                             onOpen: _onOpen,
                      //                             text: "Contacto: cjpm1983@gmail.com",
                      //                           ),
                                            
                      //                       Divider(color: Colors.yellow),
                      //                       Text("¡Que todo lo que respira cante alabanzas al Señor!¡Alabado sea el Señor! - Salmo 150:6",style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green[600]),),
                      //                       Divider(color: Colors.yellow),
                      //                       SelectableLinkify(
                      //                             onOpen: _onOpen,
                      //                             text: "Arte tarjetas cortesía: https://fb.me/oseas216",
                      //                           ),
                      //                     ]
                            
                      //   ),
                      // ),
                      // textConfirm: 'Cerrar',
                      // onConfirm: (){
                      //   Get.back();
                      //   }
                      // );
                      
                      
                      }
            
                ,
                
              ),

              Divider(),
              Obx(() => 
                            FlutterSwitch(
                              activeText: "Ahorro activado",
                              inactiveText: "Ahorro desactivado",
                              value: rx.modoAhorro ,
                              duration: Duration(milliseconds: 500),
                              
                              width: 200.0,
                              //height: 12.0,
                              //valueFontSize: 12.0,
                              //toggleSize: 45.0,
                              //borderRadius: 30.0,
                              //padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                rx.modoAhorro
                                  ?
                                  Get.defaultDialog(
                                    title: '\nConfirmación',
                                    //middleText: 'para poner contador a 0',
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                      child: Column(
                                                        children: [
                              
                                                          Text("¿Está seguro de querer desactivar el ahorro de datos? Usted se conectará directamente a la emisora con toda la calidad incurriendo en elevado gasto de datos."),
                                                          Divider(),
                                                          
                                                        ]
                                          
                                      ),
                                    ),
                                    textConfirm: 'Desactivar ahorro',
                                    textCancel: 'Cancelar',
                                    onConfirm: (){
                                      Get.back();
                                      rx.modoAhorro = false;
                                      }
                                  )
                                  :
                                  rx.modoAhorro = true;
                              },
                            ),
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

  Future<void>_onOpen(LinkableElement link) async {
    if(await canLaunch(link.url)){
        await launch(link.url);
    }
    else{
      throw 'No se pudo abrir el enlace $link, compruebe su conexión';
    }

  }
}
