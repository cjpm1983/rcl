import "package:get/get.dart";

class InicioPageController extends GetxController{
  final count = 0.obs;

  increment() => count.value++;

  inicializar() => count.value=0; 


}