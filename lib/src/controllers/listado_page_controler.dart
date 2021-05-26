import 'package:alaba/src/providers/songs_provider.dart';
import 'package:get/get.dart';

class ListDataX extends GetxController {

  // List<dynamic> canciones =  [].obs;
  // List<dynamic> cancionesAct = [].obs;

  List<dynamic> canciones =  [];
  List<dynamic> cancionesAct = [];
  int index = 0;
 

  final  query = "".obs;
  var _solofav = false.obs;

  void changesolofav(bool f){

    consulta(" ");

    _solofav.value = f;

    
    consulta("");

  }
  get solofab{
    return _solofav.value;
  }

  ListDataX(){
    cargarCanciones();    
  }
  
  void cargarCanciones() async {
    canciones = await songsProvider.cargarData();
    cancionesAct = canciones;
    update();
  }
  
  void consulta(String q) async{ 
    query.value = q; 
    //print(q);
    cancionesAct = canciones.where( (c)=>((c['titulo'].toString().toLowerCase().contains(q.toLowerCase()) && ( chequeodeFav( c ) )) )).toList()  ;
        
    // var temp = "";
    // await Future.delayed(Duration(milliseconds: 300), 
    //     ()=>{temp = "GO"}
    // );
    // print(temp);
    
    update();
    
  }

  set actual(int actual) {
    index = actual;
  }

  int get actual{
    return index;
  }


  String get consultavalue {
    return query.value;
  }


  // void persistCambios() {
  //   //tienen que ser todas las canciones,por tanto cancion act no puede ser
  //   songsProvider.guardarCanciones(cancionesAct);
  // }

bool  chequeodeFav(c) {
  return  _solofav.value?
          c['favorito'] //Si piden favoritos solo cuando favoritos es true
          :
          true //sino piden favoritos, pues todos
          ;
}



  void toggleFavorito(int index) {
    
    //Modificamos la actual
    print("antes=>${cancionesAct[index]['favorito']}");
    cancionesAct[index]['favorito'] = !cancionesAct[index]['favorito'];
    print("despues=>${cancionesAct[index]['favorito']}");

    //int idACambiar = cancionesAct[index]['cancion_id'];

    // var tempi = canciones.map( (c){
    //                                    if (c['cancion_id']==idACambiar)
    //                                     {
    //                                       print("en canciones=>${c['favorito']}");
    //                                       //c['favorito']?c['favorito']=false:c['favorito']=true;
    //                                     print(c["favorito"]);
    //                                     return c;
    //                                     }
    //                                     return c; 
    //                                 }
    //                                      ).toList();
    // canciones = tempi;

    songsProvider.guardarCanciones(canciones);
    update();

  }
    //_dx.cancionesAct[index]['favorito'] = !_dx.cancionesAct[index]['favorito'] ;

                      //Antes de persistir todas las cancioneshay que quitar elfiltrode favoritos y la busqueda
                      // String t=_dx.consultavalue;   
                      // _dx.consulta("");
                      // bool tf = _dx.solofab;
                      // _dx.changesolofav(false);

                      // _dx.persistCambios();

                      // _dx.changesolofav(tf);
                      // _dx.consulta(t);
    


 
}