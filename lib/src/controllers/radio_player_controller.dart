import 'dart:async';

import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:custom_timer/custom_timer.dart';


import 'package:alaba/src/providers/songs_provider.dart';
import 'package:volume_control/volume_control.dart';




enum Tempos { d, h2, h1, m30, m15, m5 }
enum Ahorros{desactivado, normal, moderado, extremo }

class RadioCX extends GetxController {

  
  AudioPlayer _audioPlayer;  

  var _background = false.obs;

  List<dynamic> emisoras =  []; //probable no lo use y cargue dinamico siempre

  //es mejor guardar el id de la emisora, por si la url cambiaej. 1 es transmundial
  var _idEmisoraActual = 1.obs;

  var actual = {}.obs;
  
  var _buttonState = "loading".obs;

  //static const url = 'http:cancuserver1.ddns.net:8000/rtm';
  var _url = ''.obs;

  RxDouble volumen =  0.5.obs;
  Timer timer;

  CustomTimerController tcontroller = new CustomTimerController();
  var _tempo = Tempos.h1.obs;
  var _ahorro = Ahorros.extremo.obs;
  var _t = 60.obs;

   //var _modoAhorro = true.obs;

  var _showTimer = true.obs;

  var _aviso={}.obs;
  RxBool _showAviso = true.obs;

  RadioCX(){  

    _audioPlayer = AudioPlayer();
    _init();
    
  }

  set showAviso(bool showAviso) {
    _showAviso.value=showAviso;
  }
  get showAviso{
    if (aviso['mensaje']=="")
      _showAviso.value=false;

    return _showAviso.value;
  }

  void _init() async {

    
        volumen.value = await VolumeControl.volume;
        emisoras = await songsProvider.cargarData();

        //Cargar Aviso
        _aviso.value = songsProvider.aviso;
        //print("El aviso es ${_aviso.value["mensaje"]}");
           
               
                   //await setUrl();
                   
                        _audioPlayer.playerStateStream.listen((playerState) {
                       final isPlaying = playerState.playing;
                       final processingState = playerState.processingState;
                       if (processingState == ProcessingState.loading ||
                           processingState == ProcessingState.buffering) {
                         _buttonState.value = "loading";
                       } else if (!isPlaying) {
                         _buttonState.value = "paused";
                       } else {
                         _buttonState.value = "playing";
                       }
                     });
                     }
               
                     //Se usa en init y en play para cargar la url de laemisora definida en el id dela variable Actual    
                   Future setUrl() async{
                           actual.value = emisoras.firstWhere((element) => element['id']==idEmisoraActual);
                           print("EmisoraActualID-$idEmisoraActual");
                           _url.value = getUrlValue();
                           
                           //_url.value = _modoAhorro.value?actual.value['url']:actual.value['url_full'];//seleccionar esta o url_full si ahorro esta habilitado
                           await _audioPlayer.setUrl(_url.value);
                     }
                   
                   
                   String getUrlValue() {              
                       switch (ahorro) {
                       case Ahorros.desactivado:
                           // ignore: invalid_use_of_protected_member
                           return actual.value['url_full'];
                         break;
                       case Ahorros.normal:
                           // ignore: invalid_use_of_protected_member
                           return actual.value['url_n'];
                         break;
                       case Ahorros.moderado:
                           // ignore: invalid_use_of_protected_member
                           return actual.value['url_m'];
                         break;
                       case Ahorros.extremo:
                           // ignore: invalid_use_of_protected_member
                           return actual.value['url'];
                         break;
                       default:
                           // ignore: invalid_use_of_protected_member
                           return actual.value['url'];
                     }
                   }
                     void _play() async{
                       
                       if (_background.value)
                         enBackground();
           
                       await setUrl();
                       _showTimer.value=true;
                       _audioPlayer.play();
                   
                         Timer(Duration(seconds: 1), (){
                             tcontroller.start();
                         });
                   
                     }
                     void play() {
                           _play();
                         }
                     void pause() {
                           _audioPlayer.stop();
                           //_audioPlayer.dispose();
                       
                           tcontroller.reset();
                          
                             FlutterBackground.disableBackgroundExecution();
                           
                         }
               
                         @override
                         void onClose() {   
                           
                         _audioPlayer.dispose();
                         FlutterBackground.disableBackgroundExecution();
                         super.dispose();
                       }
                       
                       
                       
                       
                         final  query = "".obs;
                       
                       
                         set buttonState(String actual) {
                           _buttonState.value = actual;
                         }
                       
                         String get buttonState{
                           return _buttonState.value;
                         }
                         
               
                         set ahorro(Ahorros modo){
                             songsProvider.ahorro = modo;
                             _ahorro.value = modo;
                           
                         }
                         get ahorro{
                           _ahorro.value = songsProvider.ahorro;
                           return _ahorro.value;
                         }
               
               
                         set tempo(Tempos tp){
                           _tempo.value = tp;
                       
                           _showTimer.value=false;
                           _audioPlayer.pause();
                           update();
                       
                           switch (_tempo.value) {
                             case Tempos.d:
                               _t.value = -1;
                               break;
                             case Tempos.h2:
                               _t.value = 120;
                               break;                    
                             case Tempos.h1:
                               _t.value = 60;
                               break;
                             case Tempos.m30:
                               _t.value = 30;
                               break;
                             case Tempos.m15:
                               _t.value = 15;
                               break;
                             case Tempos.m5:
                               _t.value = 5;
                               break;
                             default:
                           }
                           // if (_buttonState.value == "playing"){
                           //     play();
                           //     pause();
                           //   }else{
                           //     pause();
                           //     play();
                           //   }
                           
                           
                           //tcontroller.reset();
                           
                       
                         }
                       
                           
                         
                       
                       
                         get tempo{
                           return _tempo.value;
                         }
                       
                         get t{
                           return _t.value;
                         }
                         
                         get showTimer{
                           return _showTimer.value;
                         }
                   
                   
                   
                       
                       void defineCancion() {
                   
                       }
                   
                   
                     
                     
                     set idEmisoraActual(int e){
                       _idEmisoraActual.value = e;
               
                       //actualizamos para la etiqueta
                       actual.value = emisoras.firstWhere((element) => element['id']==_idEmisoraActual.value);
                       songsProvider.idEmisoraActual = e;
                       update();
                   
                       print("Cambiado a emisora $e");
                     }
                   
                     get idEmisoraActual{
                       _idEmisoraActual.value = songsProvider.idEmisoraActual;
                       update();
                       return _idEmisoraActual.value;
                     }
               
                 void enBackground() async{
                               
                           //if (_audioPlayer!=null) dispose();
                           var hasPermissions = await FlutterBackground.hasPermissions;
                           if (!hasPermissions) {
                             print('hasPermissions: $hasPermissions');
                           }
                           try {
                             final config = FlutterBackgroundAndroidConfig(
                               notificationTitle: 'Radio Cristiana Lite',
                               notificationText:
                                   'Mantener la aplicacion corriendo en background.',
                               notificationIcon: AndroidResource(name: 'ic_launcher'),
                             );
                             // Demonstrate calling initialize twice in a row is possible without causing problems.
                             hasPermissions =
                                 await FlutterBackground.initialize(androidConfig: config);
                             hasPermissions =
                                 await FlutterBackground.initialize(androidConfig: config);
                           } catch (ex) {
                             print(ex);
                           }
                           if (hasPermissions) {
                             final backgroundExecution =
                                 await FlutterBackground.enableBackgroundExecution();
                             if (backgroundExecution) {
                               try {
                                 
                               } catch (err) {
                                 print(err);
                               }
                               //return;
                          }
                    }
               }
                 
             set background(bool modo){
               _background.value = modo;
               songsProvider.background = modo;
               update();
           
               print("Cambiado a $modo");
             }
           
             get background{
               _background.value = songsProvider.background;
               update();
               
                
               return _background.value;
             }
           
             cambiavolumen(double val) {
               volumen.value = val;
               if (timer!=null){
                 timer.cancel();
               }
               timer = Timer(Duration(milliseconds:200),(){
                 VolumeControl.setVolume(val);
               });
               print("Volumen: $volumen");
             }
           
      // set modoAhorro(bool modo){
      //   _modoAhorro.value = modo;
      //   songsProvider.modoAhorro = modo;
      //   update();
    
      //   print("Cambiado a $modo");
      // }
    
      // get modoAhorro{
      //   _modoAhorro.value = songsProvider.modoAhorro;
      //   update();
      //   return _modoAhorro.value;
      // }
      get aviso{
        return _aviso.value;
      }



  }
    
