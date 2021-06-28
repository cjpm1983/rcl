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
  PermissionStatus status;
  PermissionStatus result;

  bool _download_iniciado=false;

  SendPort send;

  var _download;
  








  DownloadX(){
    _init();

  }

  Future<void> _init() async {
    //TODO _prepareSaveDir comentado *esto esimportante asegurate de que este */
    //  _prepareSaveDir();

  await _initializeFlutterDownloader();
  _downloadListener();
  
    
      
    //mio
    // IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    
    //_bindBackgroundIsolate();
    
    // _port.listen((dynamic data) {
    //   String id = data[0];
    //   DownloadTaskStatus  statusl = data[1];
    //   int progressl = data[2];
    //   print("la descarga $id - status $statusl - progreso $progressl");
    //   //setState((){ });
      
    //   update();
    // });


  }

  Future<String> newTask(String url, String nombre) async {
    

    var taskId = await FlutterDownloader.enqueue(
                                          url: url,
                                          savedDir: _localPath,//savedDir.path,
                                          fileName: nombre,//seria dinamico
                                          showNotification: true, // show download progress in status bar (for Android)
                                          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                        );

  return taskId;

  }



  @override
  void dispose() {
    //IsolateNameServer.removePortNameMapping('downloader_send_port');
    _unbindBackgroundIsolate();
    super.dispose();
  }


  //al cerrar
  @override
  void close() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  //Modificar este ejemplo,esta por lazona
  void compartir(String id, Directory tempDir){
    Share.shareFiles(['${tempDir.path}/abejita.jpg']);
  }

  // Future<List<DownloadTask>> CargarTodasLasDescargas() async{

  //   _tasks = await FlutterDownloader.loadTasks();
  //   return _tasks;
  // }

  set permissionReady(bool p){
    _permissionReady.value=p;
  }
  get permissionReady{
    return _permissionReady.value;
  }

  Future<void> retryRequestPermission() async {
    hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

      _permissionReady.value = hasGranted;
  }

  Future<void> _prepareSaveDir() async {
    _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL';

        print("LocalPath es **** $_localPath");

    var savedDir = Directory(_localPath);
          print("saveDir es **** ${savedDir.toString()}");
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  //  Future<String> _findLocalPath() async {
  //   directory =  await getExternalStorageDirectory();
  //   return directory.path;
  // }
  
  Future<bool> _checkPermission() async {
    //if (widget.platform == TargetPlatform.android) {
      status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        retryRequestPermission();
        result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
        update();
      // } else {
      //   return true;
      // }
    
  
  }
    return false;
  }



  void _unbindBackgroundIsolate() {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }

  void _bindBackgroundIsolate() {

    bool isSuccess = IsolateNameServer.registerPortWithName(
         _port.sendPort, 'downloader_send_port');
    

  
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // if (debug) {
      //   print('UI Isolate Callback: $data');
      // }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];



      // if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
      //     String query = "SELECT * FROM task WHERE task_id='" + id + "'";
      //     var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
      //     //if the task exists, open it
      //     if (tasks != null) FlutterDownloader.open(taskId: id);
      // }
   





      if (_tasks != null && _tasks.isNotEmpty) {
        task = _tasks.firstWhere((task) => task.taskId == id);
        print("***********reporte de descarga $id $status $progress");
          // task.status = status;
          // task.progress = progress;
      }
    });
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
      if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
          String query = "SELECT * FROM task WHERE task_id='" + id + "'";
          var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
          //if the task exists, open it
          if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }


  void downloadCallback( String id, DownloadTaskStatus status, int progress) {
    send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }


  void download(String url,String nombre) async {
    String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'PodcastsRCL';

    savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
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


  Future<String> findLocalPath() async {
    final directory =
        // (MyGlobals.platform == "android")
        // ?
        await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory.path;
  }

}