import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/services/app_service.dart';
import 'features/home/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: '证件照制作',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        navigatorKey: AppService().navigatorKey,
        scaffoldMessengerKey: AppService().scaffoldKey,
        initialRoute: '/',
        routes: {'/': (context) => const HomePage(), ...AppRoutes.getRoutes()},
      ),
    );
  }
}
