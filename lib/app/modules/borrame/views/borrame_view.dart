import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/borrame_controller.dart';

class BorrameView extends GetView<BorrameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BorrameView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'BorrameView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
