import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blocs_sample/src/controllers/listado_page_controler.dart';



class ListadoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListDataX dx = Get.put(ListDataX());
    print('Page ** rebuilt');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: GetBuilder<ListDataX>(
                builder: (_dx) => ListView.builder(
                    itemCount: _dx.numbers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Number: ${_dx.numbers[index]}'),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Http Request'),
                      onPressed: dx.httpCall,
                    ),
                    ElevatedButton(
                      child: Text('Reset'),
                      onPressed: dx.reset,
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}