import 'package:alaba/src/controllers/listado_page_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wakelock/wakelock.dart';

import 'cancionPage.dart';
import 'drawer.dart';

class ListadoPage extends StatelessWidget {
  final TextEditingController searchcontroller = new TextEditingController();

  // ListadoPage(){
  //     searchcontroller.addListener((){
  //       if(!searchcontroller.text.isEmpty){

  //       }
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    ListDataX dx = Get.put(ListDataX());
    print('Page ** rebuilt');
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
          title: GetBuilder<ListDataX>(
        builder: (_dx) => TextField(
          controller: searchcontroller,
          //autofocus: true,
          keyboardType: TextInputType.text,
          onChanged: (val) => _dx.consulta(val),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white54,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchcontroller.text = '';
                  _dx.consulta('');
                },
              ),
              hintText: "Buscar..."),
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: _generaListado(),
            ),
          ],
        ),
      ),
    );
  }

  _generaListado() {
    return GetBuilder<ListDataX>(
      builder: (_dx) => (  _dx.cancionesAct.length >= 1   )
          ? _listaBuilder(_dx)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                [
                  (!_dx.solofab)?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text("   Cargando"),
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No se han seleccionado favoritos aún."),
                          ],
                        ),
              ],
            ),
    );
  }

  _listaBuilder(ListDataX _dx) {
    return ListView.builder(
        itemCount: _dx.cancionesAct.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  _dx.actual = index;
                  Get.to(CancionPage());
                },
                leading: 
                
                IconButton(
                    icon: Icon(
                          Icons.star,
                          color: _dx.cancionesAct[index]['favorito']
                              ? Colors.blue[400]
                              : Colors.grey[400],
                        ),
                    onPressed: (){


                      

                      //_dx.cancionesAct[index]['favorito'] = !_dx.cancionesAct[index]['favorito'] ;

                      //Antes de persistir todas las cancioneshay que quitar elfiltrode favoritos y la busqueda
                       //String t=_dx.consultavalue;   
                      // _dx.consulta("");
                       // bool tf = _dx.solofab;
                      // _dx.changesolofav(false);

                      // _dx.persistCambios();
                      _dx.toggleFavorito(index);

                       //_dx.changesolofav(tf);
                      //_dx.consulta(t);
                      

                    }
                        ),


                title: Text(
                  '${_dx.cancionesAct[index]['titulo']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    //color: Colors.blueGrey,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              Divider(),
            ],
          );
        });
  }
}
