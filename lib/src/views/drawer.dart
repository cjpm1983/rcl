//import 'dart:html';

import 'package:alaba/src/controllers/drawer_controller.dart';
import 'package:alaba/src/controllers/radio_player_controller.dart';
//import 'package:custom_timer/custom_timer.dart';
// import 'package:alaba/src/controllers/listado_page_controler.dart';
// import 'package:alaba/src/controllers/radio_player_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
// import 'dart:async';
// import 'package:url_launcher/url_launcher.dart';

// import 'package:flutter_linkify/flutter_linkify.dart';

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
        padding: EdgeInsets.only(top: 24),
        children: <Widget>[
          //Divider(height: 24,),
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  title: Text("Radio Cristiana Lite",style:TextStyle(color:Colors.white, fontSize: 24, shadows: [Shadow(offset: Offset(-2,2))]))
                ),
              ],
            ),
            decoration: BoxDecoration(
               image: DecorationImage(
                   fit: BoxFit.fill, image: AssetImage('assets/trigo.jpg')),
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
            subtitle: Obx(() => rx.actual['nombre']!=null
                                          ?
                                            Text(" ${rx.actual['nombre']} ", 
                                               style: TextStyle( fontWeight: FontWeight.bold,color:Colors.blueAccent[400]
                                            ),
                                            )
                                          :
                                           Text("", 
                                               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, 
                                            ),
                                            )
                                          ),
            leading: Icon(Icons.radio_rounded),
            onTap: () {
              Navigator.pop(context);

              Get.defaultDialog(
                title: '\nEmisoras',
                content: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: _generaListado(rx),
                ),
              );
            },
          ),
          Obx(() => ListTile(
                title: dd.modoOscuro
                    ? Text(
                        'Modo oscuro',
                        style: _textoItemDrawer(),
                      )
                    : Text(
                        'Modo claro',
                        style: _textoItemDrawer(),
                      ),
                leading: dd.modoOscuro
                    ? Icon(Icons.nights_stay)
                    : Icon(Icons.brightness_high_sharp),
                onTap: () {
                  dd.modoOscuro = !dd.modoOscuro;
                  Get.changeTheme(
                    ThemeData(
                      brightness:
                          dd.modoOscuro ? Brightness.light : Brightness.dark,
                    ),
                  );
                },
              )),

          ListTile(
            title: Text("Autoapagado", style: _textoItemDrawer()),
            leading: Icon(Icons.av_timer_rounded),
            onTap: () {
              Navigator.pop(context);

              Get.defaultDialog(
                  title: '\nAutoapagado',
                  //middleText: 'para poner contador a 0',
                  content: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Column(children: [
                      Text(
                          "Para evitar el fuga de datos puede configurar un temporizador de autoapagado"),
                      Divider(color: Colors.yellow),
                      Obx(
                        () => Column(
                          children: [
                            RadioListTile<Tempos>(
                              title: const Text('Deshabilitado.', style: TextStyle(color:Colors.red)),
                              value: Tempos.d,
                              groupValue: rx.tempo,
                              onChanged: (Tempos value) {
                                rx.tempo = value;
                              },
                            ),
                            RadioListTile<Tempos>(
                              title: const Text('2 horas.'),
                              value: Tempos.h2,
                              groupValue: rx.tempo,
                              onChanged: (Tempos value) {
                                rx.tempo = value;
                              },
                            ),
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
                            // RadioListTile<Tempos>(
                            //   title: const Text('15 minutos.'),
                            //   value: Tempos.m15,
                            //   groupValue: rx.tempo,
                            //   onChanged: (Tempos value) {
                            //     rx.tempo = value;
                            //   },
                            // ),
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
                    ]),
                  ),
                  textConfirm: 'Cerrar',
                  onConfirm: () {
                    Get.back();
                  });
            },
          ),

          Obx(() => ListTile(
            title: Text("Reproducción de Fondo", style: _textoItemDrawer()),
                subtitle: rx.background
                    ? Text(
                        'Activado',
                        style: TextStyle(color: Colors.greenAccent[400]),
                      )
                    : Text(
                        'Desactivado',
                        style: TextStyle(color: Colors.blueGrey[400]),
                      ),
                leading: Icon(Icons.screen_lock_portrait_outlined),
                onTap: () {
                  rx.background = !rx.background;
                  
                },
              )),


          ListTile(
            title: Text("Acerca de", style: _textoItemDrawer()),
            leading: Icon(Icons.info_outline),
            onTap: () {
              Navigator.pop(context);

              Get.defaultDialog(
              title: '\nAcerca de',
              //middleText: 'para poner contador a 0',
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child: Column(
                                  children: [

                                    Text("Radio Cristiana Lite version 1.0"),
                                    Divider(),
                                    Divider(),
                                    Text("Desarrollo: "),
                                    Text("   Adrian Yanes"),
                                    Text("   Carlos J. Palacios"),
                                    Text("   Kyle Pitre"),
                                    Divider(),
                                    Text("Arte: "),
                                    Text("   Noriel S. Morales"),
                                    
                                    // SelectableLinkify(
                                    //       onOpen: _onOpen,
                                    //       text: "Contacto: cjpm1983@gmail.com",
                                    //     ),

                                    Divider(color: Colors.yellow),
                                    Text(
                                      "Hijo mío, presta atención a lo que digo y atesora mis mandatos. (...) ¡Pues el SEÑOR concede sabiduría! De su boca provienen el saber y el entendimiento.\nProverbios 2:1,6",
                                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green[600]),),
                                    Divider(color: Colors.yellow),
                                    
                                  ]

                ),
              ),
              textConfirm: 'Cerrar',
              onConfirm: (){
                Get.back();
                }
              );
            },
          ),

          // Divider(),
          // Obx(
          //   () => FlutterSwitch(
          //     activeText: "Ahorro activado",
          //     inactiveText: "Ahorro desactivado",
          //     value: rx.modoAhorro,
          //     duration: Duration(milliseconds: 500),

          //     width: 200.0,
          //     //height: 12.0,
          //     //valueFontSize: 12.0,
          //     //toggleSize: 45.0,
          //     //borderRadius: 30.0,
          //     //padding: 8.0,
          //     showOnOff: true,
          //     onToggle: (val) {
          //       rx.modoAhorro
          //           ? Get.defaultDialog(
          //               title: '\nConfirmación',
          //               //middleText: 'para poner contador a 0',
          //               content: Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                     horizontal: 10.0, vertical: 10.0),
          //                 child: Column(children: [
          //                   Text(
          //                       "¿Está seguro de querer desactivar el ahorro de datos? Usted se conectará directamente a la emisora con toda la calidad incurriendo en elevado gasto de datos."),
          //                   Divider(),
          //                 ]),
          //               ),
          //               textConfirm: 'Desactivar ahorro',
          //               textCancel: 'Cancelar',
          //               onConfirm: () {
          //                 Get.back();
          //                 rx.modoAhorro = false;
          //                 rx.pause();
          //               })
          //           : rx.modoAhorro = true;
          //     },
          //   ),
          // ),
          Divider(),

          ListTile(
            title: Text("Ahorro", style: _textoItemDrawer()),
            subtitle: Obx(() => _getSubTextAhorro(rx)),
                        leading: Icon(Icons.money_off_rounded),
                        onTap: () {
                          Navigator.pop(context);
            
                          Get.defaultDialog(
                              title: '\nAhorro de Datos',
                              //middleText: 'para poner contador a 0',
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Column(children: [
                                  Text(
                                      "Seleccione el modo de ahorro preferido"),
                                  Divider(color: Colors.yellow),
                                  Obx(
                                    () => Column(
                                      children: [
                                        RadioListTile<Ahorros>(
                                          title: const Text('Desactivado'),
                                          subtitle: const Text('No recomendado'),
                                          value: Ahorros.desactivado,
                                          groupValue: rx.ahorro,
                                          onChanged: (Ahorros value) {
                                                          Get.defaultDialog(
                                                              title: '\nConfirmación',
                                                              //middleText: 'para poner contador a 0',
                                                              content: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10.0, vertical: 10.0),
                                                                child: Column(children: [
                                                                  Text(
                                                                      "¿Está seguro de querer desactivar el ahorro de datos? Usted se conectará directamente a la emisora con toda la calidad incurriendo en elevado gasto de datos."),
                                                                  Divider(),
                                                                ]),
                                                              ),
                                                              textConfirm: 'Desactivar ahorro',
                                                              textCancel: 'Cancelar',
                                                              onConfirm: () {
                                                                Get.back();
                                                                rx.ahorro = value;
                                                                rx.pause();
                                                              });
                                          },
                                        ),
                                        RadioListTile<Ahorros>(
                                          title: const Text('Normal (Estéreo)'),
                                          subtitle: const Text('16Mb/h'),
                                          value: Ahorros.normal,
                                          groupValue: rx.ahorro,
                                          onChanged: (Ahorros value) {
                                            rx.ahorro = value;
                                            rx.pause();
                                          },
                                        ),
                                        RadioListTile<Ahorros>(
                                          title: const Text('Moderado (Mono)'),
                                          subtitle: const Text('10Mb/h'),
                                          value: Ahorros.moderado,
                                          groupValue: rx.ahorro,
                                          onChanged: (Ahorros value) {
                                            rx.ahorro = value;
                                            rx.pause();
                                          },
                                        ),
                                        RadioListTile<Ahorros>(
                                          title: const Text('Extremo (Mono)'),
                                          subtitle: const Text('6Mb/h'),
                                          value: Ahorros.extremo,
                                          groupValue: rx.ahorro,
                                          onChanged: (Ahorros value) {
                                            rx.ahorro = value;
                                            rx.pause();
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              textConfirm: 'Cerrar',
                              onConfirm: () {
                                Get.back();
                              });
                        },
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
            
              // Future<void> _onOpen(LinkableElement link) async {
              //   if (await canLaunch(link.url)) {
              //     await launch(link.url);
              //   } else {
              //     throw 'No se pudo abrir el enlace $link, compruebe su conexión';
              //   }
              // }
            
              _generaListado(RadioCX rx) {
                // return DropdownButton(items: rx.emisoras.map((e) {
                //   return DropdownMenuItem(
                //     child: Text(e['nombre'])
                //   );
                // }).toList(),
                // );
                return  Column(
                      children: rx.emisoras.map((e) {
                        return ListTile(
                          title: Text(e["nombre"]),
                          onTap: (){
                            rx.idEmisoraActual = e["id"];
                            rx.pause();
                            if (rx.buttonState=="playing"){
                              rx.play();
                            }
                            Get.back();
            
                          },
                          
                        );
                      }).toList(),
                    );
            
              }
            
              Text _getSubTextAhorro(RadioCX rx) {
                Text t;
                switch (rx.ahorro) {
                  case Ahorros.desactivado:
                    t = Text("Desactivado, Alto Consumo", style: TextStyle(color: Colors.red[400] ));
                    break;
                  case Ahorros.normal:
                    t = Text("Normal 16Mb/h", style: TextStyle(color: Colors.blueAccent[400] ));
                    break;
                  case Ahorros.moderado:
                    t = Text("Moderado 10Mb/h", style: TextStyle(color: Colors.orangeAccent[400] ));
                    break;
                  case Ahorros.extremo:
                    t = Text("Extremo 6Mb/h", style: TextStyle(color: Colors.green[400] ));
                    break;
                }
              return t;
              }

              
}
