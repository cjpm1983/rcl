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
        title:             Obx(() => rx.actual['nombre']!=null
                                          ?
                                            Text(" ${rx.actual['nombre']} ", 
                                               //style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,
                                           // ),
                                            )
                                          :
                                           Text("Radio Cristiana Lite", 
                                               //style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, 
                                           // ),
                                            )
                                          )
        
        
        ,
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
                      width: 200.0,
                      height: 200.0,
                    )
                  : rx.buttonState == "loading"
                      ?
                      Image(
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
                        style: TextStyle(fontSize: 24,)
                      );
                    },
                    onFinish: () {
                      rx.pause();
                      rx.tcontroller.reset();
                    } //resetBuilder: ,
                    ),
              ),
            ),
            Spacer(),
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
          icon: Icon(Icons.play_circle_outline, color: Colors.lightGreen[400]),
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
          icon: Icon(Icons.stop_circle_outlined, color: Colors.redAccent[400]),
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
