import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:custom_timer/custom_timer.dart';


import 'package:alaba/src/providers/songs_provider.dart';




enum Tempos { h1, m30, m15, m5 }

class RadioCX extends GetxController {

  
  AudioPlayer _audioPlayer;  

  List<dynamic> emisoras =  []; //probable no lo use y cargue dinamico siempre

  //es mejor guardar el id de la emisora, por si la url cambiaej. 1 es transmundial
  var _idEmisoraActual = 1.obs;
  
  var _buttonState = "loading".obs;

  //static const url = 'http:cancuserver1.ddns.net:8000/rtm';
  var _url = ''.obs;

  CustomTimerController tcontroller = new CustomTimerController();
  var _tempo = Tempos.h1.obs;
  var _t = 60.obs;

   var _modoAhorro = true.obs;

  var _showTimer = true.obs;

  RadioCX(){  
    _audioPlayer = AudioPlayer();
    _init();
  }

  void _init() async {


    //if (_audioPlayer!=null) dispose();


    emisoras = await songsProvider.cargarData();

    var actual = emisoras.firstWhere((element) => element['id']==idEmisoraActual);
    
    _url.value = _modoAhorro.value?actual['url']:actual['url_full'];//seleccionar esta o url_full si ahorro esta habilitado


    
    
    
  
    await _audioPlayer.setUrl(_url.value);

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

  void play() {
         //_audioPlayer = AudioPlayer();
        _init();
        _showTimer.value=true;
        //tcontroller.reset();
        _audioPlayer.play();
        
        Timer(Duration(seconds: 1), (){
            tcontroller.start();
        });
        
      }
      void pause() {
        _audioPlayer.stop();
        //_audioPlayer.dispose();
    
        tcontroller.reset();
        
      }
    
      void dispose() {    
      _audioPlayer.dispose();
    }
    
    
    
      final  query = "".obs;
    
    
      set buttonState(String actual) {
        _buttonState.value = actual;
      }
    
      String get buttonState{
        return _buttonState.value;
      }
      
      set tempo(Tempos tp){
        _tempo.value = tp;
    
        _showTimer.value=false;
        _audioPlayer.pause();
        update();
    
        switch (_tempo.value) {
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
    songsProvider.idEmisoraActual = e;
    update();

    print("Cambiado a emisora $e");
  }

  get idEmisoraActual{
    _idEmisoraActual.value = songsProvider.idEmisoraActual;
    update();
    return _idEmisoraActual.value;
  }
  
  set modoAhorro(bool modo){
    _modoAhorro.value = modo;
    songsProvider.modoAhorro = modo;
    update();

    print("Cambiado a $modo");
  }

  get modoAhorro{
    _modoAhorro.value = songsProvider.modoAhorro;
    update();
    return _modoAhorro.value;
  }

  }
    
