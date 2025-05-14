import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teko/core/resource/string_resource.dart';
import 'package:teko/features/products/data/models/product_model.dart';
import 'package:teko/features/products/domain/bloc/product_cubit.dart';
import 'package:teko/features/products/view/component/text_form_field.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({super.key});

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final StringResources s = StringResources();
  final ImagePicker _picker = ImagePicker();
  ValueNotifier<bool> isValid = ValueNotifier(false);
  ValueNotifier<XFile?> imageNotifier = ValueNotifier(null);
  Product newProduct = Product.empty;

  Future pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    imageNotifier.value = img;
    newProduct = newProduct.copyWith(imageSrc: img?.path);
  }

  void removeImage() {
    imageNotifier.value = null;
    newProduct = newProduct.copyWith(imageSrc: defaultImageUrl);
  }

  void addProduct() {
    context.read<ProductCubit>().addProduct(newProduct);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text.rich(
          TextSpan(children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.only(right: 5),
                child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.tertiary, size: 20,)
                )
              ),
            TextSpan(
              text: s.addedProductSuccessfully,
              style: Theme.of(context).textTheme.bodySmall),
            ]
          )
        )
      ),
    );
  }

  bool isValidForm() {
    return (newProduct.name.isNotEmpty && newProduct.name.length < 20 )
      && (newProduct.price > 10000 && newProduct.price <= 100000000);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 6,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(s.addProduct, style: Theme.of(context).textTheme.titleMedium),
            ),
            _labelWidget(title: s.productName),
            CustomTextFormField(
              onChanged: (value) {
                newProduct = newProduct.copyWith(name: value);
                // check valid
                isValid.value = isValidForm();
              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length > 20) {
                  return false;
                }
                return true;
              },
              errorText: (value) {
                if (value == null || value.isEmpty) {
                  return s.pleaseEnterName;
                } 
                if (value.length > 20) {
                  return s.productNameNotValid;
                }
                return null;
              },
            ),
            _labelWidget(title: s.productPrice),
            CustomTextFormField(
              onChanged: (value) {
                newProduct = newProduct.copyWith(price: double.tryParse(value) ?? 0);
                // check valid
                isValid.value = isValidForm();
              },
              isOnlyNumber: true,
                validator: (value) {
                final price = int.tryParse(value ?? "0") ?? 0;
                  if (price < 10000 || price > 100000000) {
                    return false;
                  }
                  return true;
              },
              errorText: (value) {
                final price = int.tryParse(value ?? "0") ?? 0;
                if (value == null || value.isEmpty) {
                  return s.pleaseEnterPrice;
                }
                if (price < 10000 || price > 100000000) {
                  return s.priceNotValid;
                }
                return null;
              },
            ),
            _labelWidget(title: s.productImage, isRequired: false),
            ValueListenableBuilder(
              valueListenable: imageNotifier, 
              builder: (context, value, child) {
                return imageNotifier.value != null ? _buildImageWidget() : _buildSelectImageButton();
              }
            ),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _labelWidget({required String title, bool isRequired = true}) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            if (isRequired)
            TextSpan(text: "*",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red)),
            TextSpan(text: title, style: Theme.of(context).textTheme.labelSmall)
          ]
        ),
      )
    );
  }

  Widget _buildImageWidget() {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imageNotifier.value!.path), 
              width: double.infinity, 
              fit: BoxFit.cover
            )
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: removeImage,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface, size: 20,)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectImageButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: pickImage,
          borderRadius: BorderRadius.circular(8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: Theme.of(context).colorScheme.onSurface, size: 20,),
                  Text(s.selectFile, style: Theme.of(context).textTheme.bodySmall,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ValueListenableBuilder(
      valueListenable: isValid,
      builder: (context, value, child) => Material(
        color: value 
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isValid.value ? addProduct : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              s.createProduct, 
              style: value 
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.labelSmall,
            )
          ),
        ),
      ),
    );
  }
}