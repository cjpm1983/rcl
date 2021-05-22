import 'package:get/get.dart';

import 'package:blocs_sample/app/modules/borrame/bindings/borrame_binding.dart';
import 'package:blocs_sample/app/modules/borrame/views/borrame_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.BORRAME,
      page: () => BorrameView(),
      binding: BorrameBinding(),
    ),
  ];
}
