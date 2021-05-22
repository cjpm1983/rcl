import 'package:blocs_sample/src/controllers/listado_page_controler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CancionPage extends StatelessWidget {
  const CancionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListDataX>(
      builder: (_dx) {
        return Container(
          child: Scaffold(
                    appBar: AppBar( title: Text( _dx.cancionesAct[_dx.actual]['titulo'] ) ),
                    body: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: ListView(
                                            children: [
                                              Text(_dx.cancionesAct[_dx.actual]['cancion'],
                                                    style: TextStyle(fontSize: 20.0),
                                                   )
                                            ],
                                    ),
                            ),
                            
                        ),
                    ),
          ),
        );
        }
      );
  }

}