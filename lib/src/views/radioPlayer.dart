//import 'package:alaba/src/controllers/drawer_controller.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wakelock/wakelock.dart';
import 'package:alaba/src/controllers/radio_player_controller.dart';

import 'drawer.dart';
//import 'package:just_audio/just_audio.dart';

class RadioPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //_tcontroller.start();
    Wakelock.enable();
    RadioCX rx = Get.put(RadioCX());
    //DrawerX dd = Get.put(DrawerX());
    return Scaffold(
      appBar: AppBar(
        title: Text("Radio Cristiana Cuba"),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx(
              () => rx.buttonState == "playing"
                  ? Image(
                      image: AssetImage('assets/music.gif'),
                      width: 150.0,
                      height: 150.0,
                    )
                  : rx.buttonState == "loading"
                      ? Text(
                          "Cargando...",
                          textScaleFactor: 2.0,
                        )
                      : Text(
                          "Pausado",
                          textScaleFactor: 2.0,
                        ),
            ),
            Spacer(),

            Obx(
              () => Visibility(
                visible: rx.showTimer,
                child: CustomTimer(
                    controller: rx.tcontroller,
                    from: Duration(minutes: rx.t),
                    to: Duration(minutes: 0),
                    builder: (CustomTimerRemainingTime remaining) {
                      return Text(
                        "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                        style: TextStyle(fontSize: 30.0),
                      );
                    },
                    onFinish: () {
                      rx.pause();
                      rx.tcontroller.reset();
                    } //resetBuilder: ,
                    ),
              ),
            ),
            // Obx(()  {
            //   if (dd.t>0){

            //   }
            //   dd.tcontroller.reset();
            //   return Text("${dd.t}");
            //   }),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => botonPrincipal(rx)),
              ],
            ),
            Spacer(),
            //Obx(() => Text("${rx.emisoras[rx.idEmisoraActual]['nombre']}")),
          ],
        ),
      ),
    );
  }

  botonPrincipal(RadioCX rx) {
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
          icon: Icon(Icons.play_circle_outline, color: Colors.lightGreen),
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
          icon: Icon(Icons.stop_circle_outlined, color: Colors.red[400]),
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
}
