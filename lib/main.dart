import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/controllers/auth_toggle.dart';
import 'features/controllers/form_controller.dart';
import 'features/services/auth_service.dart';
import 'features/views/initial_view/initial_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthToggle(),
      ),
      ChangeNotifierProvider(
        create: (_) => FormController(),
      ),
      Provider<AuthService>(
        create: (_) => AuthService(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'CoFlow App',
            theme: ThemeData(
              primaryColor: salmon,
              primarySwatch: salmon,
              backgroundColor: Colors.white,
              unselectedWidgetColor: const Color(0xffd8d8d8),
              iconTheme: const IconThemeData(color: Colors.white),
              colorScheme: appColorScheme,
            ),
            home: const InitialView(),
            debugShowCheckedModeBanner: false,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
