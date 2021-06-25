import 'dart:async';
import 'package:alaba/src/reproductor/views/common.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as Rxd;
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:custom_timer/custom_timer.dart';


import 'package:alaba/src/providers/podcast_provider.dart';
import 'package:volume_control/volume_control.dart';



class PodcastCX extends GetxController {

  
  AudioPlayer _player;  
  var _playlist = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(  
                  Uri.parse("https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/los_obstaculos_de_la_vida_cristiana.mp3"),
                  tag: AudioMetadata(
                    album: "De prueba Inicial",
                    title: "Datos Iniciales",
                    artwork: "https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/images/logo.jpg",
                  ),
                ),
      ]
    ).obs;
  RxList<dynamic> _podcasts =  [].obs;
  RxMap _aviso = {}.obs;// tiene tipo y mensaje
  RxBool _showAviso = true.obs;
  //Del Podcast
  RxInt _idactual = 1.obs;
  RxMap _actual = {}.obs;

  SequenceState _state;
  List<IndexedAudioSource> _sequence;
  PositionData _positionData;
  AudioMetadata _metadata;
  LoopMode _loopMode;

  RxBool _shuffleModeEnabled = false.obs;
  RxBool _enable = false.obs;
  RxInt _index = 0.obs;

  

  AudioSession session;


  set showAviso(bool showAviso) {
    _showAviso.value=showAviso;
  }
  get showAviso{
    if (aviso['mensaje']=="")
      _showAviso.value=false;

    return _showAviso.value;
  }
 set aviso(Map aviso) {
    _aviso.value = aviso;
  }
  get aviso{
    return _aviso.value;
  }

 set index(int index) {
    _index.value = index;
  }
  get index{
    return _index.value;
  }

 set loopMode(LoopMode loopMode) {
    _loopMode = loopMode;
    update();
  }
  get loopMode{
    return _loopMode;
  }

 set metadata(AudioMetadata  metadata) {
    _metadata = metadata;
    update();
  }
  get metadata{
    return _metadata;
  }

 set enable(bool enable) {
    _enable.value = enable;
  }
  get enable{
    return _enable.value;
  }

 set shuffleModeEnabled(bool shuffleModeEnabled) {
    _shuffleModeEnabled.value = shuffleModeEnabled;
  }
  get shuffleModeEnabled{
    return _shuffleModeEnabled.value;
  }

   set positionData(PositionData positionData) {
    _positionData = positionData;
    update();
  }
  get positionData{
    return _positionData;
  }


  set sequence(List<IndexedAudioSource> sequence) {
    _sequence = sequence;
    update();
  }
  get sequence{
    return _sequence;
  }

  get state{
    return _state;
  }

  set state(SequenceState p){
    _state = p;
    update();
  }

  get player{
    return _player;
  }
  set player(AudioPlayer p){
    _player = p;
  }

  get idactual{
    return _idactual.value;
  }

  set idactual(int act){
    _idactual.value = act;
  }

  get actual{
    return _actual.value;
  }

  set actual(RxMap act){
    _actual.value = act;
  }

    get podcasts{
    return _podcasts.value;
  }

  set podcasts(RxList act){
    _podcasts.value = act;
  }
  
    
    
    get playlist{
      return _playlist.value;
    }


    
    
      
      PodcastCX(){  
    
        _player = AudioPlayer();
        
        _init();
        
      }
    
        Future<void> _init() async {
    
          _podcasts.value = await PodcastsProvider.cargarData();
          //print(podcasts);
          _actual.value = _podcasts.value[0];//.firstWhere((p) => true);//p["id"] = idactual);
          print("Aqui----${_actual.value["arte"]}");

          //La lista de capitulos a mostrar dentro del podcast _actual
          
          //*****Descomenta esto
          _recargarPlayList();
          //print(PodcastsProvider.aviso["tipo"]);
          _aviso.value = PodcastsProvider.aviso;
    
    
    
        session = await AudioSession.instance;
        await session.configure(AudioSessionConfiguration.speech());
        // Listen to errors during playback.
        _player.playbackEventStream.listen((event) {},
            onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
        try {
          await _player.setAudioSource(playlist);
          print("playlist aniadida");
        } catch (e) {
          // Catch load errors: 404, invalid url...
          print("Error loading audio source: $e");
        }
      }
    
      @override
      void dispose() {
        _player.stop();
        _player.dispose();
        super.dispose();
      }
    
    
      Stream<PositionData> get positionDataStream =>
          Rxd.Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
              _player.positionStream,
              _player.bufferedPositionStream,
              _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
                  position, bufferedPosition, duration ?? Duration.zero));
    
      List<AudioSource> _listadoDePodcasts() {
        return actual["capitulos"].map((p) => AudioSource.uri(  
                  Uri.parse(p["url"]),
                  tag: AudioMetadata(
                    album: actual["podcast"],
                    title: p["titulo"],
                    artwork: "https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/images/logo.jpg",
                  ),
                ),
            ).toList();
  
  }
          
      void _recargarPlayList() {
              _playlist.value = ConcatenatingAudioSource(
            children: //_listadoDePodcasts()
            List.generate(actual["capitulos"].length, (index) => 
            
                AudioSource.uri(  
                  Uri.parse(actual["capitulos"][index]["url"]),
                  tag: AudioMetadata(
                    album: actual["podcast"],
                    title: actual["capitulos"][index]["titulo"],
                    subtitle: actual["capitulos"][index]["por"],
                    size: actual["capitulos"][index]["size"],
                    artwork: actual["capitulos"][index]["arte"],
                  ),
                ),
            )


            );



// [

// actual["capitulos"].map((p) => AudioSource.uri(  
//                   Uri.parse(p["url"]),
//                   tag: AudioMetadata(
//                     album: actual["podcast"],
//                     title: p["titulo"],
//                     artwork: "https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/images/logo.jpg",
//                   ),
//                 ),
//             ).toList()
//             ]



            // [
            //   AudioSource.uri(  
            //       Uri.parse("https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/los_obstaculos_de_la_vida_cristiana.mp3"),
            //       tag: AudioMetadata(
            //         album: "De prueba Inicial1",
            //         title: "Datos Iniciales1",
            //         artwork: "https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/images/logo.jpg",
            //       ),
            //     ),
            //     AudioSource.uri(  
            //       Uri.parse("https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/los_obstaculos_de_la_vida_cristiana.mp3"),
            //       tag: AudioMetadata(
            //         album: "De prueba Inicial2",
            //         title: "Datos Iniciales2",
            //         artwork: "https://raw.githubusercontent.com/cjpm1983/db/60bd886c40ebea465510fd7653138fab18d4e652/podcasts/images/logo.jpg",
            //       ),
            //     ),
            // ]
            }

  Future<bool> cerrar() async{
    
        _player.stop();
        //_player.dispose();
    return true;
  }




  }
    

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Volumen",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Velocidad (1 es normal)",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;
  final String subtitle;
  final double size;

  AudioMetadata({
     this.album,
     this.title,
     this.artwork, 
     this.subtitle, 
     this.size, 
  });
}
