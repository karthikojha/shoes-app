import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Added this import
import 'package:kpf/database/userprovider.dart'; // 2. Added your provider file
import 'package:kpf/screens/kpf.dart';
import 'package:kpf/log/reg/registor.dart';
import 'package:kpf/etc/spalsh.dart';

void main() {
  runApp(
    // 3. Wrap the entire app here
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}
