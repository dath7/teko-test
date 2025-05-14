import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teko/features/products/data/models/product_model.dart';

class ProductGridview extends StatelessWidget {
  final List<Product> listProduct;
  const ProductGridview({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    // lazy load
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
        final bool isNetworkUrl = product.imageSrc.contains("https://");

        Widget buildNetWorkImg() {
          return CachedNetworkImage(
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
          );
        }

        Widget buildImageFile() {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(File(product.imageSrc)),
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: isNetworkUrl ? buildNetWorkImg() : buildImageFile()
            ),
            Text(product.name, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),
            Text("${product.price.toString()} đ", style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      }
    );
  }
}