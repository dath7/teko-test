import 'package:hive/hive.dart';
import 'package:teko/features/products/data/models/product_model.dart';
import 'package:teko/features/products/domain/network/product_api.dart';

class ProductRepo {
  static Future<List<Product>> getListProduct({Function()? onError}) async {
    final dataFromHive = await getDataFromHive();
    final res = await ProductApi.getListProduct(onError: onError);
    try {
      final productData = res.firstWhere((e) => e["type"] == "ProductList");

      return (productData["customAttributes"]["productlist"]["items"] as List)
        .map((e) => Product.fromJson(e)).toList()
        ..addAll(dataFromHive);
    }
    catch (e) {
      onError?.call();
      return [];
    }
  }

  static Future<void> addProduct(Product product) async {
    // create box if not exist
    var box = Hive.box('product');
    final List data = box.get("items") ?? [];
    data.add(product.toJson());
    await box.put("items", data);
  }

  static Future<List<Product>> getDataFromHive() async {
    var box = await Hive.openBox('product');
    return ((box.get("items") ?? []) as List).map((e) =>  Product.fromJson(e)).toList();
  }
}
