import 'package:alaba/src/providers/songs_provider.dart';
import 'package:get/get.dart';

class ListDataX extends GetxController {

  List<dynamic> canciones =  [];
  List<dynamic> cancionesAct = List<dynamic>.from([]);
  int index = 0;
 

  final  query = "".obs;
  var _solofav = false.obs;

  void changesolofav(bool f){
    _solofav.value = f;
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
    cancionesAct = canciones.where( (c)=>((c['titulo'].toString().toLowerCase().contains(q.toLowerCase()) && ( chequeodeFav( c ) )) )).toList();
        
            var temp = "";
            await Future.delayed(Duration(milliseconds: 300), 
               ()=>{temp = "GO"}
            );
            print(temp);
            
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
        
        
          void persistCambios() {
            songsProvider.guardarCanciones(cancionesAct);
          }
    
        bool  chequeodeFav(c) {
          return  _solofav.value?
                  c['favorito'] //Si piden favoritos solo cuando favoritos es true
                  :
                  true //sino piden favoritos, pues todos
                  ;
      }
    
    


 
}