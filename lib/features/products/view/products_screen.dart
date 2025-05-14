import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teko/core/resource/string_resource.dart';
import 'package:teko/features/products/data/repo/product_repo.dart';
import 'package:teko/features/products/domain/models/product_model.dart';
import 'package:teko/features/products/view/component/add_product_modal.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final StringResources s = StringResources();
  List<Product> listProduct = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getListProduct();
  }

  void getListProduct() {
    ProductRepo.getListProduct(onError: onError).then((value) {
      setState(() {
        listProduct = value;
        isLoading = false;
      });
    });
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
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: const AddProductModal()
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
              Expanded(child: isLoading ? _shimmerEffect() : _buildGridProducts())
            ],
          ),
        ),
      ),
    );
  }


  Widget _shimmerEffect() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = constraints.maxWidth * 0.05;
        const double textSize = 14;
        final itemWidth = (constraints.maxWidth - spacing * 2) / 2;
        
        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Shimmer.fromColors(
              baseColor: const Color(0xffe2e5e8),
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(10, (i) => i).map((_) => SizedBox(
                  width: itemWidth,
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Container(
                        height: textSize,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      Container(
                        height: textSize,
                        width: itemWidth * 0.4, // 40% of item width
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridProducts() {
    return GridView.builder(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ), 
      itemCount: listProduct.length,
      itemBuilder: (context, index) {
        final product = listProduct[index];

        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product.imageSrc, 
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(product.name, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),
            Text("${product.price.toString()} USD", style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      });
  }
}
