import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teko/core/resource/string_resource.dart';
import 'package:teko/features/products/domain/bloc/product_cubit.dart';
import 'package:teko/features/products/domain/bloc/product_state.dart';
import 'package:teko/features/products/view/component/add_product_modal.dart';
import 'package:teko/features/products/view/component/product_error.dart';
import 'package:teko/features/products/view/component/product_gridview.dart';
import 'package:teko/features/products/view/component/product_loading.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final StringResources s = StringResources();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getListProduct();
  }

  void onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          s.loadingError,  
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true,
            builder: (context) {
              return BlocProvider.value(
                value: this.context.read<ProductCubit>(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const AddProductModal()
                ),
              );
            });
        }, 
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(child: Text(s.productManagement, style: Theme.of(context).textTheme.titleLarge)),
              ),
              Expanded(
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ProductFetching.loading: return ProductLoading();
                      case ProductFetching.failure: return ProductError();
                      case ProductFetching.success: return ProductGridview(listProduct: state.products);
                      default: return SizedBox();
                    }
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
