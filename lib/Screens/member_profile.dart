// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sqlitedb_demo/Model/member_model.dart';

import '../Provider/member_provider.dart';
import '../Widgets/loading_indicator.dart';
import '../constant/string_constant.dart';

class MemberProfile extends StatefulWidget {
  MemberModel objMember;
  MemberProfile({super.key, required this.objMember});

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  //-------------------------Variables-----------------------//
  TextEditingController txtPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LoadingIndicatorNotifier _loadingIndicatorNotifier =
      LoadingIndicatorNotifier();
  MemberProvider get getMemberProvider =>
      Provider.of<MemberProvider>(context, listen: false);
  final ValueNotifier _editNotifier = ValueNotifier(true);
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    txtPhoneController.text = widget.objMember.phone.toString();
  }

  @override
  void dispose() {
    txtPhoneController.dispose();
    super.dispose();
  }

  //-------------------------UI-----------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

//-------------------------Widgets-----------------------//
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(StringConstant.memberProfile),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          }),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
        child: Container(
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          height: 215,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(widget.objMember.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25)),

                //TextField
                _buildTextField(),
                const SizedBox(height: 10),

                Text(
                  "Type Name : ${widget.objMember.typeName}",
                ),
                const SizedBox(height: 20),

                //delete Button
                _buildDeleteBtn(widget.objMember.id)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //TextField
  Widget _buildTextField() {
    return ValueListenableBuilder(
      valueListenable: _editNotifier,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            (isEdit)
                ? Expanded(child: _buildMobileTextField())
                : Expanded(
                    child: Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(width: 15),
                      Text(txtPhoneController.text),
                    ],
                  )),
            const SizedBox(width: 10),
            TextButton(
                onPressed: () {
                  if (isEdit) {
                    _editOnTap(widget.objMember.id, txtPhoneController.text);
                  }
                  isEdit = !isEdit;

                  _editNotifier.notifyListeners();
                },
                child: Text(
                  isEdit ? "Submit" : "Edit",
                  style: const TextStyle(
                      color: Colors.indigo, fontWeight: FontWeight.bold),
                )),
          ],
        );
      },
    );
  }

  //delete Alert
  Widget _alertDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Text(StringConstant.deleteMember, textAlign: TextAlign.center),
      content:
          Text(StringConstant.deleteMemberDesc, textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _textButton(StringConstant.delete, () {
                _onDelete(index);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: _textButton(StringConstant.cancel, () {
                Navigator.of(context).pop();
              }),
            ),
          ],
        )
      ],
    );
  }

  //Text Button
  Widget _textButton(String title, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo)),
      onPressed: onPressed,
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  //Add Button
  Widget _buildDeleteBtn(int id) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _alertDialog(context, id);
            });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.indigo,
        ),
        child: const Text(
          StringConstant.delete,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  //mobile Field
  Widget _buildMobileTextField() {
    return TextFormField(
        keyboardType: TextInputType.phone,
        maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return StringConstant.phoneValid;
          } else if (value.length < 10) {
            return StringConstant.phoneValid1;
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: txtPhoneController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.phone),
          hintText: StringConstant.enterPhone,
          counterText: "",
        ));
  }

//-------------------------OnTap-----------------------//
  //delete button onTap
  _onDelete(int id) async {
    try {
      _loadingIndicatorNotifier.show(
          loadingIndicatorType: LoadingIndicatorType.spinner);
      await getMemberProvider.deleteMember(id);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _loadingIndicatorNotifier.hide();
    }
  }

//Edit button onTap
  Future<void> _editOnTap(int id, String mobile) async {
    if (_formKey.currentState!.validate()) {
      try {
        _loadingIndicatorNotifier.show(
            loadingIndicatorType: LoadingIndicatorType.spinner);
        await getMemberProvider.editMobile(id, mobile);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        _loadingIndicatorNotifier.hide();
      }
    }
  }
}
