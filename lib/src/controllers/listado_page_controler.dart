import 'package:blocs_sample/src/providers/songs_provider.dart';
import 'package:get/get.dart';

class ListDataX extends GetxController {

  List<dynamic> canciones =  [];
  List<dynamic> cancionesAct = List<dynamic>.from([]);
  int index = 0;
 

  final  query = "".obs;

  set actual(int actual) {
    index = actual;
  }

  int get actual{
    return index;
  }

  set consulta(String q){ 
    query.value = q; 
    print(q);
    cancionesAct = canciones.where( (c)=>c['titulo'].toString().toLowerCase().contains(q.toLowerCase()) ).toList();
    update();
    
    }

  String get consulta {
    return query.value;
  }

  ListDataX(){
    cargarCanciones();    
  }

  void cargarCanciones() async {
    canciones = await songsProvider.cargarData();
    cancionesAct = canciones;
    update();
  }


}