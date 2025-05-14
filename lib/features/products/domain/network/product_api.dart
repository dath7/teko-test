import 'package:dio/dio.dart';

final Dio _dio = Dio()..options.baseUrl = "https://hiring-test.stag.tekoapis.net/api"
    ..options.connectTimeout = const Duration(seconds: 8)
    ..options.receiveTimeout = const Duration(seconds: 20)
    ..options.sendTimeout = const Duration(seconds: 15);

class ProductApi {
  static Future<List<Map<String, dynamic>>> getListProduct({Function()? onError}) async {
    try {
        final res = await _dio.get("/products/management");
        return (res.data["data"] as List).cast<Map<String, dynamic>>();
    } 
    catch (e) {
        onError?.call();
        return [];
    }
  }
}