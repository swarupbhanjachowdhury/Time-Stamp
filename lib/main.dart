import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/storage.dart';

import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Storage(),
      child: MaterialApp(
        title: 'Time Stamp',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.redAccent,
          // textTheme: TextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
