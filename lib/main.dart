import 'package:band_names/pages/status.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:band_names/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SocketService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomePage(),
          'status': (context) => const StatusPage(),
        },
        // home: const HomePage(),
      ),
    );
  }
}
