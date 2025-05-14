import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductLoading extends StatelessWidget {
  const ProductLoading({super.key});

  @override
  Widget build(BuildContext context) {
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
}