import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlitedb_demo/Provider/member_provider.dart';
import 'package:sqlitedb_demo/Screens/add_member_screen.dart';
import 'package:sqlitedb_demo/Screens/view_member_screen.dart';

import '../constant/string_constant.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    Provider.of<MemberProvider>(context, listen: false).createDB();
    super.initState();
  }

  //-------------------------Screen-----------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  //-------------------------Widget-----------------------//
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(StringConstant.dashboard),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //add Button
          _buildAddBtn(),
          //view Button
          _buildViewBtn(),
        ],
      ),
    );
  }

//add Button
  Widget _buildAddBtn() {
    return GestureDetector(
        onTap: () => addOnTap(),
        child: Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            height: 100,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade400,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: const Text(
              StringConstant.addMember,
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )));
  }

//view Button
  Widget _buildViewBtn() {
    return GestureDetector(
        onTap: () => viewOnTap(),
        child: Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            height: 100,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade400,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: const Text(
              StringConstant.viewMember,
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )));
  }

//-------------------------onTap-----------------------//
//addOnTap
  void addOnTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddMemberScreen(),
      ),
    );
  }

//viewOnTap
  void viewOnTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ViewMemberScreen(),
      ),
    );
  }
}
