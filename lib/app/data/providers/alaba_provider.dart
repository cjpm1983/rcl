import 'package:get/get.dart';

import '../models/alaba_model.dart';

class AlabaProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Alaba.fromJson(map);
      if (map is List) return map.map((item) => Alaba.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Alaba?> getAlaba(int id) async {
    final response = await get('alaba/$id');
    return response.body;
  }

  Future<Response<Alaba>> postAlaba(Alaba alaba) async =>
      await post('alaba', alaba);
  Future<Response> deleteAlaba(int id) async => await delete('alaba/$id');
}
