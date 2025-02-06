import 'package:flutter/material.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/router.dart';
import 'package:ham_lookup/widgets/app_bar_generator.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      child: AppBarGenerator(
        child: MaterialApp.router(
          title: 'Ham Lookup',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
