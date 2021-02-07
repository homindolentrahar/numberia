import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numberia/features/number_trivia/presentation/pages/main_page.dart';
import 'package:numberia/injection_container.dart' as di;

const String CACHE_BOX = "CACHE_BOX";

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(CACHE_BOX);
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}
