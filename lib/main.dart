import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_toggle.dart';
import 'controllers/form_controller.dart';
import 'controllers/product_controller.dart';
import 'services/auth_service.dart';
import 'views/initial_view/initial_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthToggle(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductController(),
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
              primaryColor: Colors.teal,
              primarySwatch: Colors.deepOrange,
              iconTheme: const IconThemeData(color: Color(0xffEAEAE9)),
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
