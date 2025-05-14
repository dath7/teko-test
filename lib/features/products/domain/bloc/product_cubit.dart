import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teko/features/products/data/models/product_model.dart';
import 'package:teko/features/products/data/repo/product_repo.dart';
import 'package:teko/features/products/domain/bloc/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState(status: ProductFetching.initial, products: []));

  Future<void> getListProduct() async {
    emit(state.copyWith(status: ProductFetching.loading));
    try {
      final products = await ProductRepo.getListProduct();
      emit(state.copyWith(status: ProductFetching.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductFetching.failure));
    }
  }

  Future<void> addProduct(Product product) async {
    List productList = state.products;
    // not load again to preserve scroll position
    // emit(state.copyWith(status: ProductFetching.loading));
    // await Future.delayed(const Duration(milliseconds: 500));
    await ProductRepo.addProduct(product);
    emit(state.copyWith(status: ProductFetching.success, products: [...productList, product]));
  }
}