import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlitedb_demo/Provider/member_provider.dart';
import 'package:sqlitedb_demo/Screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MemberProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
