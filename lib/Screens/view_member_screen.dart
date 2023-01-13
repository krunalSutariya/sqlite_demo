import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sqlitedb_demo/Screens/add_member_screen.dart';
import 'package:sqlitedb_demo/Screens/member_profile.dart';

import '../Provider/member_provider.dart';
import '../Widgets/loading_indicator.dart';
import '../constant/string_constant.dart';

class ViewMemberScreen extends StatefulWidget {
  const ViewMemberScreen({super.key});

  @override
  State<ViewMemberScreen> createState() => _ViewMemberScreenState();
}

class _ViewMemberScreenState extends State<ViewMemberScreen> {
  //-------------------------Variables-----------------------//

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  MemberProvider get getMemberProvider =>
      Provider.of<MemberProvider>(context, listen: false);

  @override
  void initState() {
    getAllMember();
    super.initState();
  }

  @override
  void dispose() {
    _loadingIndicatorNotifier.dispose();
    super.dispose();
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
        title: const Text(StringConstant.viewMember),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AddMemberScreen()),
                );
              },
              icon: const Icon(Icons.add))
        ]);
  }

  Widget _buildBody() {
    return Consumer<MemberProvider>(
      builder: (context, memberProvider, child) {
        return ListView.builder(
          itemCount: memberProvider.arrMember.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => MemberProfile(
                        objMember: memberProvider.arrMember[index]),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 3.0,
                      spreadRadius: 0.0,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    memberProvider.arrMember[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(
                      "Type : ${memberProvider.arrMember[index].typeName}"),
                ),
              ),
            );
          },
        );
      },
    );
  }

//-------------------------Function-----------------------//

  //get all member
  Future<void> getAllMember() async {
    try {
      _loadingIndicatorNotifier.show(
          loadingIndicatorType: LoadingIndicatorType.spinner);
      await getMemberProvider.getAllMember();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }
}
