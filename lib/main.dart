import 'features/controllers/auth_toggle.dart';
import 'features/controllers/form_controller.dart';
import 'features/services/auth_service.dart';
import 'features/views/initial_view/initial_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Map<int, Color> salmonOpacity = {
      50: const Color.fromRGBO(4, 131, 184, .1),
      100: const Color.fromRGBO(4, 131, 184, .2),
      200: const Color.fromRGBO(4, 131, 184, .3),
      300: const Color.fromRGBO(4, 131, 184, .4),
      400: const Color.fromRGBO(4, 131, 184, .5),
      500: const Color.fromRGBO(4, 131, 184, .6),
      600: const Color.fromRGBO(4, 131, 184, .7),
      700: const Color.fromRGBO(4, 131, 184, .8),
      800: const Color.fromRGBO(4, 131, 184, .9),
      900: const Color.fromRGBO(4, 131, 184, 1),
    };
    MaterialColor salmon = MaterialColor(0xffFF7465, salmonOpacity);

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
              colorScheme: const ColorScheme(
                  primary: Color(0xffFF7465),
                  primaryVariant: Color(0xffFF7465),
                  secondary: Colors.blue,
                  secondaryVariant: Colors.blueAccent,
                  surface: Colors.white,
                  background: Colors.transparent,
                  error: Colors.red,
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  onSurface: Color(0xffFF7465),
                  onBackground: Colors.grey,
                  onError: Colors.white,
                  brightness: Brightness.light),
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
