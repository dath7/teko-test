import 'package:flutter/material.dart';
import 'package:teko/core/resource/string_resource.dart';

class ProductError extends StatelessWidget {
  const ProductError({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final StringResources s = StringResources();

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Image.asset(
            "assets/images/empty_box.png",
            height: screenSize.height * 0.2, 
            width: screenSize.height * 0.2,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.2, vertical: screenSize.height * 0.01),
            child: Text(
              s.noData,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}