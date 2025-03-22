import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_provider.dart';
import 'core/routes/app_routes.dart';
import 'core/services/app_service.dart';
import 'features/home/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ID Photo Maker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      navigatorKey: AppService().navigatorKey,
      scaffoldMessengerKey: AppService().scaffoldKey,
      // 移除 home 属性，在 routes 中定义初始路由
      initialRoute: '/',  // 添加这行
      routes: {
        '/': (context) => const HomePage(),
        ...AppRoutes.getRoutes(),
      },
    );
  }
}
