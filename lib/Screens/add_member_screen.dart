import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sqlitedb_demo/Model/member_type_model.dart';
import 'package:sqlitedb_demo/Provider/member_provider.dart';

import '../Widgets/loading_indicator.dart';
import '../constant/string_constant.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  //-------------------------Variables-----------------------//
  final _formKey = GlobalKey<FormState>();

  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();

  List<MemberType> arrMemberType = [
    MemberType(1, 'Type 1'),
    MemberType(2, 'Type 2')
  ];

  MemberType? selectedMemberType;

  final ValueNotifier _dropdownNotifier = ValueNotifier(true);

  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();

  MemberProvider get getMemberProvider =>
      Provider.of<MemberProvider>(context, listen: false);

  @override
  void dispose() {
    _loadingIndicatorNotifier.dispose();
    _dropdownNotifier.dispose();
    txtNameController.dispose();
    txtPhoneController.dispose();
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
      title: const Text(StringConstant.addMember),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),

              //Name TextField
              _buildNameTextField(),
              const SizedBox(height: 20),

              //Phone TextField
              _buildPhoneTextField(),
              const SizedBox(height: 20),

              //MemberType Dropdown
              _memberTypeDropDown(),
              const SizedBox(height: 20),

              //add Button
              _buildAddBtn(),
            ],
          )),
    );
  }

  //Name TextField
  TextFormField _buildNameTextField() {
    return TextFormField(
      controller: txtNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return StringConstant.nameValid;
        }
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0)),
          filled: true,
          fillColor: Colors.black12,
          hintText: StringConstant.enterName),
    );
  }

  //Phone TextField
  TextFormField _buildPhoneTextField() {
    return TextFormField(
      controller: txtPhoneController,
      maxLength: 10,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return StringConstant.phoneValid;
        } else if (value.length < 10) {
          return StringConstant.phoneValid1;
        }
        return null;
      },
      decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0)),
          filled: true,
          fillColor: Colors.black12,
          hintText: StringConstant.enterPhone),
    );
  }

  //MemberType Dropdown
  Widget _memberTypeDropDown() {
    return ValueListenableBuilder(
      valueListenable: _dropdownNotifier,
      builder: (context, value, child) {
        return DropdownButtonHideUnderline(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0)),
            child: DropdownButton<MemberType>(
              hint: const Text(
                StringConstant.memberType,
              ),
              items: arrMemberType
                  .map<DropdownMenuItem<MemberType>>((MemberType value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.title),
                );
              }).toList(),
              isExpanded: true,
              isDense: true,
              onChanged: (MemberType? newSelectedValue) {
                selectedMemberType = newSelectedValue;
                _dropdownNotifier.notifyListeners();
              },
              value: selectedMemberType,
            ),
          ),
        );
      },
    );
  }

  //Add Button
  Widget _buildAddBtn() {
    return InkWell(
      onTap: _btnOnTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.indigo,
        ),
        child: const Text(
          StringConstant.addMember,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

//-------------------------onTap-----------------------//

  //Add button onTap
  void _btnOnTap() async {
    if (_formKey.currentState!.validate()) {
      if (selectedMemberType == null) {
        Fluttertoast.showToast(msg: StringConstant.typeValid);
        return;
      }
      Random random = Random();
      int randomNumber = random.nextInt(99999 - 10000) + 10000;
      try {
        _loadingIndicatorNotifier.show(
            loadingIndicatorType: LoadingIndicatorType.spinner);
        await getMemberProvider.addMember(
            randomNumber,
            txtNameController.text,
            txtPhoneController.text,
            selectedMemberType?.id ?? 0,
            selectedMemberType?.title ?? "");
        Navigator.of(context).pop();
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        _loadingIndicatorNotifier.hide();
      }
    }
  }
}
