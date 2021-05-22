import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:blocs_sample/src/controllers/listado_page_controler.dart';

import 'cancionPage.dart';

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
    ListDataX dx = Get.put(ListDataX());
    print('Page ** rebuilt');
    return Scaffold(
      appBar: AppBar(
          title: GetBuilder<ListDataX>(
        builder: (_dx) => TextField(
          controller: searchcontroller,
          //autofocus: true,
          keyboardType: TextInputType.text,
          onChanged: (val) => _dx.consulta = val,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white54,
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  searchcontroller.text = '';
                  _dx.consulta = '';
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
              child: _GeneraListado(),
            ),
          ],
        ),
      ),
    );
  }

  _GeneraListado() {
    return GetBuilder<ListDataX>(
      builder: (_dx) => ((_dx.cancionesAct.length > 1))
          ? _ListaBuilder(_dx)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("   Cargando"),
                  ],
                ),
              ],
            ),
    );
  }

  _ListaBuilder(ListDataX _dx) {
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
                    // FavoriteButton(
                    //       isFavorite: _dx.cancionesAct[index]['favorito'],
                    //       // iconDisabledColor: Colors.white,
                    //       valueChanged:(_isFavourite){

                    //         _dx.cancionesAct[index]['favorito']=!_dx.cancionesAct[index]['favorito'];
                    //         print(_dx.cancionesAct[index]);
                    //       },
                    //     ),
                
                IconButton(
                    icon: Icon(
                          Icons.star,
                          color: _dx.cancionesAct[index]['favorito']
                              ? Colors.blue[400]
                              : Colors.grey[400],
                        ),
                    onPressed: (){
                      _dx.cancionesAct[index]['favorito'] = !_dx.cancionesAct[index]['favorito'];
                      String t=_dx.consulta="";                    
                      _dx.consulta="";
                      _dx.consulta=t;

                    }
                        ),


                title: Text(
                  '${_dx.cancionesAct[index]['titulo']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey,
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
