import 'package:get/get.dart';

class ListDataX extends GetxController {
  List<int> numbers = List<int>.from([0,1,2,3]);

  void httpCall() async {
    await Future.delayed(Duration(seconds: 1), 
            () => numbers.add(numbers.last + 1)
    );
    update();
  }

  void reset() {
    numbers = numbers.sublist(0, 3);
    update();
  }
}