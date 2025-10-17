import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'core/app_export.dart';
import 'widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set device orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Vista',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          initialRoute: AppRoutes.initial,
          routes: AppRoutes.routes,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Page not found')),
              ),
            );
          },
        );
      },
    );
  }
}