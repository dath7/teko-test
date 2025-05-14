import 'package:equatable/equatable.dart';
import 'package:teko/features/products/data/models/product_model.dart';

enum ProductFetching { initial, loading, success, failure }

extension ProductFetchingStatus on ProductFetching {
  bool get isInitial => this == ProductFetching.initial;
  bool get isLoading => this == ProductFetching.loading;
  bool get isSuccess => this == ProductFetching.success;
  bool get isFailure => this == ProductFetching.failure;
}

final class ProductState extends Equatable {
  final ProductFetching status;
  final List<Product> products;

  const ProductState({
    required this.status,
    required this.products,
  });

  ProductState copyWith({
    ProductFetching? status,
    List<Product>? products,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, products];
}