import 'package:alaba/src/reproductor/controllers/download_controler.dart';
import 'package:alaba/src/reproductor/views/podcast.dart';
import 'package:flutter/material.dart';

import 'package:alaba/src/reproductor/controllers/podcast_controller.dart';
import 'package:get/get.dart';

class Podcasts extends StatelessWidget {
  const Podcasts({Key key}) : super(key: key);

 

  @override
  Widget build(BuildContext context) {
    PodcastCX px = Get.put(PodcastCX());
    DownloadX dw = Get.find<DownloadX>();
    

return Scaffold(
      appBar: AppBar(title: Text("Listado de Podcast"),),
      body:  Obx(()=>px.podcasts.length==0
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
       ListView.builder(
        itemCount: px.podcasts.length ,
        itemBuilder:(context,index)=> ListTile(
            leading: Image.network(px.podcasts[index]["arte"], 
                // fit: BoxFit.fill,
                // alignment: Alignment.center,
                ),
            title:Text(px.podcasts[index]["podcast"]),
            subtitle:Text(px.podcasts[index]["descripcion"]),
            trailing: Icon(Icons.chevron_right_rounded),
            
            onTap: () async{
              px.idactual=px.podcasts[index]["id"];
              px.actual=px.podcasts[index];
              
              await px.agregarPlaylistAlPlayer();

              //Una inicializacion para refrescar las listas con losoffline
              dw.capitulos_descargados = 0;
              
              //print("seleccionado el id  ${px.idactual} con objeto actual ${px.actual} ");

              Get.to(()=>Podcast());
            }
                
            ), 
      
          
      )
      )
    );
  }
}