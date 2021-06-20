import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:alaba/src/controllers/drawer_controller.dart';
import 'package:alaba/src/widgets/header_square.dart';
import 'package:custom_timer/custom_timer.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wakelock/wakelock.dart';

import 'package:alaba/src/controllers/radio_player_controller.dart';
import 'drawer.dart';
//import 'package:just_audio/just_audio.dart';

class RadioPlayer extends StatelessWidget {
  // RadioPlayer(){
  //   RadioCX rx = Get.put(RadioCX());

  // }

  @override
  Widget build(BuildContext context) {
    //_tcontroller.start();
    Wakelock.enable();
    RadioCX rx = Get.put(RadioCX());
    DrawerX dd = Get.put(DrawerX());

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Builder(builder: (context) {
            return IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer());
          }),
          elevation: 0,
        ),
        drawer: DrawerWidget(),
        body: Stack(
          children: [
            Obx(() => HeaderDiagonal(dd.modoOscuro)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  

                  Obx(
                    () => rx.buttonState == "playing"
                        ? Image(
                            image: AssetImage('assets/music.gif'),
                            width: 200.0,
                            height: 200.0,
                          )
                        : rx.buttonState == "loading"
                            ? Image(
                                image: AssetImage('assets/musicstop.png'),
                                width: 200.0,
                                height: 200.0,
                              )
                            : Image(
                                image: AssetImage('assets/musicstop.png'),
                                width: 200.0,
                                height: 200.0,
                              ),
                  ),
                  Obx(() => TextButton(
                        child: rx.actual['nombre'] != null
                            ? Text(" ${rx.actual['nombre']} ",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: dd.modoOscuro
                                      ? Colors.white
                                      : Colors.grey[400],
                                ),
                                textAlign: TextAlign.center)
                            : Text("Radio Cristiana Lite",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: dd.modoOscuro
                                      ? Colors.white
                                      : Colors.grey[400],
                                ),
                                textAlign: TextAlign.center),
                        onPressed: () {
                          //Navigator.pop(context);

                          Get.defaultDialog(
                            title: '\nEmisoras',
                            content: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: _generaListado(rx),
                            ),
                          );
                        },
                      )),
                  //Spacer(),
                  //Divider(),
                  Obx(() => botonPrincipal(context, rx, dd)),

                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      //color: Colors.grey[300]
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_down),
                        Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackShape: RectangularSliderTrackShape(),
                                  trackHeight: 4.0,
                                  thumbShape: RoundSliderThumbShape()),
                              child: Slider(
                                value: rx.volumen.value,
                                min: 0,
                                max: 1,
                                divisions: 100,
                                onChanged: (val) => rx.cambiavolumen(val),
                                label: "${(rx.volumen * 100).toInt()}%",
                              ),
                            )),
                        Icon(Icons.volume_up),
                      ],
                    ),
                  ),
                  Spacer(),

                  Obx(
                    () => Visibility(
                      visible: rx.showTimer,
                      child: CustomTimer(
                          controller: rx.tcontroller,
                          from: rx.t > 0
                              ? Duration(minutes: rx.t)
                              : Duration(minutes: 1440),
                          to: Duration(minutes: 0),
                          builder: (CustomTimerRemainingTime remaining) {
                            return rx.tempo == Tempos.d
                                ? Text.rich(TextSpan(
                                    text: "Autoapagado: ",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 18,
                                    ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                          text: "Desactivado",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          )),
                                    ],
                                  ))
                                : Text(
                                    "Autoapagado: ${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).accentColor));
                          },
                          onFinish: () {
                            rx.pause();
                            rx.tcontroller.reset();
                          } //resetBuilder: ,
                          ),
                    ),
                  ),

                  Spacer(flex: 1), //Text("buttonState${rx.buttonState}"),
                ],
              ),
            ),
            //Aviso
                  //Obx(() => Text("${rx.aviso["mensaje"]}")),
                  Obx(
                    () => Container(
                            
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              
                              children: [
                                  Visibility(
                                          visible: rx.aviso["mensaje"]!=null && rx.showAviso,
                                          child: 
                                                Container(  
                                                  padding: EdgeInsets.all(20.0),
                                                  margin: EdgeInsets.all(10.0),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.yellow,
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),   
                                                  child: Column(
                                                    children: [
                                                        Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.warning_amber_rounded),
                                                              Spacer(flex:1),
                                                              Text("${_tituloDeAviso(rx.aviso)}\n",style:TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold )),
                                                              Spacer(flex:2),
                                                              IconButton(icon: Icon(Icons.close), onPressed: ()=>rx.showAviso=false),
                                                            ],
                                                          ),
                                                        ),
                                                        SelectableLinkify(
                                                                    onOpen: _onOpen,
                                                                    text: "${rx.aviso["mensaje"]}",
                                                                    style:TextStyle(fontSize: 18.0 )
                                                                  ),

                                                    ],
                                                  )

                                                ),
                                             
                                            ),
                            ],
                            )
                            
                      
                    )
                    ),
          ],
        ));
  }

  botonPrincipal(context, RadioCX rx, DrawerX dd) {
    switch (rx.buttonState) {
      case "loading":
        return Container(
          margin: EdgeInsets.all(8.0),
          width: 120.0,
          height: 120.0,
          child: CircularProgressIndicator(),
        );
      case "paused":
        return IconButton(
          icon: Icon(Icons.play_circle_outline,
              //color:Theme.of(context).accentColor),
              color: Colors.greenAccent[200]),
          iconSize: 120.0,
          onPressed: () {
            rx.play();
            //rx.tcontroller.start();rx.tcontroller.start();rx.tcontroller.start();rx.tcontroller.start();
            //rx.buttonState = "playing";
            print(rx.buttonState);
          },
        );
      case "playing":
        return IconButton(
          icon: Icon(
            Icons.stop_circle_outlined,
            color: dd.modoOscuro ? Colors.white : Colors.grey[400],
          ),
          iconSize: 120.0,
          onPressed: () {
            rx.pause();
            //rx.tcontroller.reset();
            print(rx.buttonState);
          },
        );
      default:
        return Container(
          margin: EdgeInsets.all(8.0),
          width: 120.0,
          height: 120.0,
          child: CircularProgressIndicator(),
        );
    }
  }

  _generaListado(RadioCX rx) {
    // return DropdownButton(items: rx.emisoras.map((e) {
    //   return DropdownMenuItem(
    //     child: Text(e['nombre'])
    //   );
    // }).toList(),
    // );
    return Column(
      children: rx.emisoras.map((e) {
        return ListTile(
          title: Text(e["nombre"]),
          onTap: () {
            rx.idEmisoraActual = e["id"];
            rx.pause();
            if (rx.buttonState == "playing") {
              rx.play();
            }
            Get.back();
          },
        );
      }).toList(),
    );
  }



  String _tituloDeAviso(aviso) {
    String a = "";
    switch (aviso["tipo"]) {
      case "normal":
        a = '\nInformación';
        break;
      case "mantenimiento":
        a = '\nMantenimiento';
        break;
      case "critico":
        a = '\nAtención';
        break;
      default:
        a = '\nInformación';
    }
    return a;
  }

Text _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
    return Text("");
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
