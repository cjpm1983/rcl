import 'dart:io';
import 'dart:isolate';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

//https://png.pngtree.com/png-vector/20190119/ourlarge/pngtree-cartoon-cartoon-bee-bee-little-bee-png-image_474598.jpg


class DownloadX extends GetxController {

  //Directory tempDir;
  ReceivePort _port = ReceivePort();
  List<DownloadTask> _tasks ;
  DownloadTask task;
  String _localPath;
  RxBool _permissionReady = false.obs;
  Directory savedDir;
  Directory directory;
  bool hasGranted;
  //PermissionStatus status;
  PermissionStatus result;

  bool _download_iniciado=false;

  //SendPort send;

  var _download;

  RxInt _capitulos_descargados = 0.obs;

  set capitulos_descargados(int c){
    _capitulos_descargados.value = c;
  }
  get capitulos_descargados{
    return _capitulos_descargados.value;
  }
  
  set localPath(String l){
    _localPath = l;
  }
  get localPath{
    return _localPath;
  }


  

  DownloadX(){
    _init();
  }

  Future<void> _init() async {
      await _initializeFlutterDownloader();
      downloadListener();

      String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL';



  }

  void verTareas() async{
              String query = "SELECT * FROM task";
          var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
          //if the task exists, open it
          if (tasks.length > 0){
            tasks.map((t)=> print(t) );
            //Pero en task tenemos todo lo necesario
            print("Tareas => ${tasks}");
            } 
  }


  @override
  void dispose() {
    //IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    //_unbindBackgroundIsolate();
    super.dispose();
  }



  //Modificar este ejemplo,esta por lazona
  void compartir(String nombre)async{
    String path = (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL'+ Platform.pathSeparator + nombre;
    Share.shareFiles([path]);
  }


  set permissionReady(bool p){
    _permissionReady.value=p;
  }
  get permissionReady{
    return _permissionReady.value;
  }

  Future<void> retryRequestPermission() async {
    hasGranted = await _checkPermission();

    if (hasGranted) {
      //TODO  Importante
      await crearDirectorio();
    }

      _permissionReady.value = hasGranted;
  }
 
  Future<bool> _checkPermission() async {
    //if (widget.platform == TargetPlatform.android) {
      PermissionStatus status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        //retryRequestPermission();
        result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
        update();    
  
  }
    return false;
  }



  void _unbindBackgroundIsolate() {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }



  

//Delnuevo ejemplo
_initializeFlutterDownloader() async{
    WidgetsFlutterBinding.ensureInitialized();
await FlutterDownloader.initialize();
print("****Seinicializo el flutterDownloader*******");
    _download_iniciado=true;
}


  _downloadListener() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      //Aqui se hace una verificacion a ver si esta completada

      // if (progress == -1 ) {
      //   print("Ya se descargo********************************************");
      //     abrirArchivoTarea(id);
      // }       
      if (progress == 100 && id != null) {
          capitulos_descargados++;
      }      
      if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
          abrirArchivoTarea(id);
          capitulos_descargados++;
      }

    });
    FlutterDownloader.registerCallback(downloadCallback);
  }


//   void downloadCallback( String id, DownloadTaskStatus status, int progress) {
//     send = IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }

//   FlutterDownloader.registerCallback(downloadCallback); 

static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    
      //print('Reporte **** Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    
    //final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);


  }


  void download(String url,String nombre) async {
   print("*************COMENZAR DESCARGA****************");
    //Primero verificamos si el archivo existe ya en el directorio
    bool descargado = await yaDescargado(nombre);
    print("descargado $descargado");
    
    if (descargado){
      
          capitulos_descargados++;
    }
    else{

    String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL';


    savedDir = Directory(_localPath);

    if (!permissionReady){
        await retryRequestPermission();
    }
    else{
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
        print("Directorio de descargas creado");
      }
    }

    String _url = url;
    _download = await FlutterDownloader.enqueue(
      url: _url,
      savedDir: _localPath,
      fileName: nombre,
      showNotification: true,
      openFileFromNotification: true,
    );
    
    }
  }

  Future<bool> yaDescargado(String nombre) async{
    String path = (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL'+ Platform.pathSeparator + nombre;
    print("Comprobando $path");
    bool existe = await File(path).exists();

    bool descargadoCompleto=false;
    String query = 'SELECT * FROM task WHERE file_name = "'+nombre+'" AND progress=100';
    var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
    //print(" que bola ${tasks[0]}");
    if (tasks.length>0){
    //if (true){
        descargadoCompleto=true;
    }
    return (existe && descargadoCompleto);
  }

  void crearDirectorio() async{
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
        print("Directorio de descargas creado");
      }
  }

  Future<String> findLocalPath() async {
    final directory =
        // (MyGlobals.platform == "android")
        // ?
        await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void downloadListener() {
    _downloadListener();
  }

  void abrirArchivoTarea(String id) async{
    String query = "SELECT * FROM task WHERE task_id='" + id + "'";
    var tasks = await FlutterDownloader.loadTasksWithRawQuery(query: query);
    //if the task exists, open it
    if (tasks != null){
      //Esto permite abrir elarchivo si hay con que
      //FlutterDownloader.open(taskId: id);
      //Pero en task tenemos todo lo necesario
      print("Tarea completada => ${tasks}");
      //tasks.map((t)=>print("a ver si se desgloza ${tasks[0].progress}"));
      
      capitulos_descargados++;
      } 

  }

}