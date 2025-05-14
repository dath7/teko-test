import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teko/features/products/domain/bloc/product_cubit.dart';
import 'package:teko/features/products/view/products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var newDir = await getApplicationSupportDirectory();
  var newPathHive = "${newDir.path}/app_data";
  Hive.init(newPathHive);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: const Color(0xFFF4F4F5) ,
          surfaceContainerHighest: Color(0xFFC1C1C2),
          surfaceContainerLow: const Color(0xFFE3E3E5),
          onSurface: const Color(0xFF333334),
          primary: const Color(0xFF4FA0FA),
          tertiary:  Color(0xff1AAF4E),
        ),
         textTheme: TextTheme(
          
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333334),
            fontFamily: "Inter"
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333334),
            fontFamily: "Inter"
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333334),
            fontFamily: "Inter"
          ),
          labelSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666667),
            fontFamily: "Inter"
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => ProductCubit(),
        child: const ProductScreen()),
    );
  }
}
