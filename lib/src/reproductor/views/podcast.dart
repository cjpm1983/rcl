import 'package:alaba/src/reproductor/controllers/download_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alaba/src/reproductor/controllers/podcast_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common.dart';

class Podcast extends StatelessWidget {
  const Podcast({Key key}) : super(key: key);

 
  
  Widget build(BuildContext context) {
    PodcastCX px = Get.find<PodcastCX>();
    DownloadX dw = Get.find<DownloadX>();
    //dw.downloadListener();
    return Container(
      child: WillPopScope(
        onWillPop:()=>px.cerrar(),
        child: Scaffold(
        appBar: AppBar(
          title: Text("Podcast"),          
        ),
        body: SafeArea(
          child: Stack(
            children:[Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: 
                Obx(()=>
                px.podcasts.length==0 || px.state==null
                  ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator()
                        ),
                    ],
                  )
                  :
                  //Todo dice que esta cargandodatos de nulono se qu epueda ser
                  StreamBuilder<SequenceState>(
                  stream: px.player.sequenceStateStream,
                  builder: (context, snapshot) {
                    px.state = snapshot.data;
                    print("snapshot-----$snapshot");
                    try {
                      if (px.state==null) return SizedBox();
                      //print("dentrodel try ${px.state.sequence.isEmpty}");
                      
                    } catch (e) {
                      print("Este es elbateo $e");
                    }
                    px.metadata = px.state.currentSource.tag as AudioMetadata;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // TextButton(child:Text("ver Tareas"),
                        // onPressed: (){
                        //     dw.verTareas();
                        // }
                        // ),
                        // TextButton(child:Text("Descargar Abejita"),
                        // onPressed: (){
                        //     dw.CargarTodasLasDescargas();
                        // }
                        // ),
                        // TextButton(child:Text("permisos"),
                        // onPressed: (){
                        //     dw.retryRequestPermission();
                        // }
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(px.metadata.artwork),

                          ),
                        ),
                        Text(px.metadata.title,
                            style: Theme.of(context).textTheme.headline6),
                        Text(px.metadata.album),
                      ],
                    );
                  },
                )
              ),

              
              ),
              ControlButtons(px.player),
              StreamBuilder<PositionData>(
                stream: px.positionDataStream,
                builder: (context, snapshot) {
                  px.positionData = snapshot.data;
                  return SeekBar(
                    duration: px.positionData?.duration ?? Duration.zero,
                    position: px.positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        px.positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      px.player.seek(newPosition);
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  // StreamBuilder<LoopMode>(
                  //   stream: px.player.loopModeStream,
                  //   builder: (context, snapshot) {
                  //     px.loopMode = snapshot.data ?? LoopMode.off;
                  //     const icons = [
                  //       Icon(Icons.repeat, color: Colors.grey),
                  //       Icon(Icons.repeat, color: Colors.orange),
                  //       Icon(Icons.repeat_one, color: Colors.orange),
                  //     ];
                  //     const cycleModes = [
                  //       LoopMode.off,
                  //       LoopMode.all,
                  //       LoopMode.one,
                  //     ];
                  //     px.index = cycleModes.indexOf(px.loopMode);
                  //     return IconButton(
                  //       icon: icons[px.index],
                  //       onPressed: () {
                  //         px.player.setLoopMode(cycleModes[
                  //             (cycleModes.indexOf(px.loopMode) + 1) %
                  //                 cycleModes.length]);
                  //       },
                  //     );
                  //   },
                  // ),
                  Expanded(
                    child: Text(
                      "Pistas",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(icon: Icon(Icons.info_outline,color: Colors.orange,),
                  //accion de Boton de informacion
                                  onPressed: () {
                                          Get.defaultDialog(
                                          title: "\n"+px.actual["podcast"],
                                          //middleText: 'para poner contador a 0',
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                            child: Column(
                                                              children: [

                                                                Divider(),

                                                                

                                                                Divider(color: Colors.yellow),
                                                                SelectableLinkify(
                                                                      onOpen: _onOpen,
                                                                      text: px.actual["descripcion"],
                                                                    
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
                  // StreamBuilder<bool>(
                  //   stream: px.player.shuffleModeEnabledStream,
                  //   builder: (context, snapshot) {
                  //     px.shuffleModeEnabled = snapshot.data ?? false;
                  //     return IconButton(
                  //       icon: px.shuffleModeEnabled
                  //           ? Icon(Icons.shuffle, color: Colors.orange)
                  //           : Icon(Icons.shuffle, color: Colors.grey),
                  //       onPressed: () async {
                  //         px.enable = !px.shuffleModeEnabled;
                  //         if (px.enable) {
                  //           await px.player.shuffle();
                  //         }
                  //         await px.player.setShuffleModeEnabled(px.enable);
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
              Container(
                height: 240.0,
                child: StreamBuilder<SequenceState>(
                  stream: px.player.sequenceStateStream,
                  builder: (context, snapshot) {
                    px.state = snapshot.data;
                    //px.sequence= px.state.sequence==null?[]:px.state.sequence;
                    px.sequence = px.state?.sequence ?? [];

                    return Obx(()=>ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex > newIndex) newIndex--;
                        px.playlist.move(oldIndex, newIndex);
                      },
                      children: [
                        for (var i = px.sequence.length-1; i >= 0; i--)
                          Dismissible(
                            key: ValueKey(px.sequence[i]),
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                            onDismissed: (dismissDirection) {
                               px.playlist.removeAt(i);
                            },
                            child: Material(
                              color: i == px.state.currentIndex
                                  ? Colors.grey.shade300
                                  : null,
                              child: ListTile(
                                leading: (dw.capitulos_descargados>0 || true)// Al azar Para que el bloque se recargue compleltocuando se descarguen capitulos
                                ?
                                 IconButton(icon: Icon(Icons.info_sharp),

                                  //accion de Boton de informacion
                                  onPressed: () {
                                          Get.defaultDialog(
                                           
                                          title: "\n"+px.sequence[i].tag.title,
                                          //middleText: 'para poner contador a 0',
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                            child: Container(
                                              width: double.maxFinite,
                                              height: 250.0,
                                              child: ListView(
                                                                children: [

                                                                  Image.network(
                                                                    px.sequence[i].tag.artwork=="" ?                                                                  
                                                                    px.actual["arte"] :
                                                                    px.sequence[i].tag.artwork                                                                   
                                                                    , 
                                                                  width: 150.0,
                                                                  height:150.0,
                                                                  ),

                                                                  Divider(),

                                                                  

                                                                  Divider(color: Colors.yellow),
                                                                  SelectableLinkify(
                                                                        onOpen: _onOpen,
                                                                        text: px.sequence[i].tag.info as String,
                                                                      ),
                                                                  Text(px.sequence[i].tag.subtitle as String,
                                                                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green[600]),),
                                                                  
                                                                  Divider(color: Colors.yellow),
                                                                  
                                                                ]

                                              ),
                                            ),
                                          ),
                                          textConfirm: 'Cerrar',
                                          onConfirm: (){
                                            Get.back();
                                            }
                                          );
                                        },


                                  
                                )
                                 :
                                 Text("error"),
                                
                                title: Text(px.sequence[i].tag.title as String),
                                subtitle: Text(px.sequence[i].tag.subtitle as String),
                                trailing: acciones(i,px,dw),
                                onTap: () {
                                  px.player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                      ],
                    )
                );
                  },
                ),
              ),
            ],
          ),
            
                  Obx(
                    () => Container(
                            
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              
                              children: [
                                  Visibility(
                                          visible: px.aviso["mensaje"]!=null && px.showAviso,
                                          child: 
                                                Container(  
                                                  padding: EdgeInsets.all(20.0),
                                                  margin: EdgeInsets.all(10.0),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.blue[400],
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
                                                              Text("${_tituloDeAviso(px.aviso)}\n",style:TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold )),
                                                              Spacer(flex:2),
                                                              IconButton(icon: Icon(Icons.close), onPressed: ()=>px.showAviso=false),
                                                            ],
                                                          ),
                                                        ),
                                                        SelectableLinkify(
                                                                    onOpen: _onOpen,
                                                                    text: "${px.aviso["mensaje"]}",
                                                                    style:TextStyle(fontSize: 18.0 , color: Colors.white)
                                                                  ),

                                                    ],
                                                  )

                                                ),
                                             
                                            ),
                            ],
                            )
                            
                      
                    )
                    ),
            
            ])//stack
        ),
       
      ),
    
    ),
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


    Future<void>_onOpen(LinkableElement link) async {
    if(await canLaunch(link.url)){
        await launch(link.url);
    }
    else{
      throw 'No se pudo abrir el enlace $link, compruebe su conexión';
    }

  }

  acciones(int i, PodcastCX px,DownloadX dw) {
    return FutureBuilder<bool>(
      future: dw.yaDescargado("${px.idactual}_$i.mp3"),
      initialData: false,
      builder:(context, snapshot){
        return snapshot.data
              ?
              ElevatedButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share_outlined, size:20)
                  ],
                ),
                onPressed: ()=>dw.compartir("${px.idactual}_$i.mp3")
                  )
              :
              ElevatedButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download_sharp, size:20),
                    Text("${px.sequence[i].tag.size}Mb")
                  ],
                ),
                onPressed: ()=>dw.download(                                        
                  px.actual["capitulos"][i]["url"],
                  "${px.idactual}_$i.mp3"
                  )
                  );

      }
    );
  }

}



