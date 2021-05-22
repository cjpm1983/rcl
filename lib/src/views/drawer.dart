import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: ()=>Navigator.pop(context), 
                          ),
                          Text('Ajustes Personalizados'),
                          
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    //Para cerrar
                    Navigator.pop(context);
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
    );
  }
}