import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_live_code/model/user_model.dart';
import 'package:test_live_code/screen/widget/custom_button_primary.dart';
import 'package:test_live_code/utils/database_helper.dart';
import 'package:test_live_code/utils/flushbar_notif.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _email,_password;
  bool showPassword  = true;

  LocalStorage localStorage = LocalStorage("tes_live_code");


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Masukkan Email",
                      ),
                      onSaved: (val) => _email = val,
                      validator: (val) => val == null || val.isEmpty ? "Email tidak boleh kosong": val.isValidEmail() ? null : "Format email salah",
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      obscureText: showPassword,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: Icon(showPassword
                              ? Icons.visibility_off
                              : Icons.visibility, size: 16,color: Colors.blue,),
                        ),
                        hintText: "Masukkan Password",
                      ),
                      onSaved: (val) => _password = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed("/register");
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Buat Akun",style: TextStyle(decoration: TextDecoration.underline,fontSize: 12,color: Colors.black),),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Container(
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomButtonPrimary(
                      color: Colors.blue,
                      hasWidth: true,
                      hasHeight: true,
                      isBorder: false,
                      title: "Login".toUpperCase(),
                      customTextSize: 12,
                      textColor: Colors.white ,
                      isEnable: true,
                      btnLoading: false,
                      onTap: (){
                        _submit();
                      },
                      borderRadius: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        form.save();
        loginUser(_email,_password);
      });
    }
  }

  void _showSnackBar(String text,BuildContext context,Color colorBacground) {
    FlushbarNotif.flushbarTop(context, FlushbarPosition.TOP, text, Colors.white, colorBacground);
  }

  void loginUser( String email, String password) async {
    var user = new UserModel(null,null, email,null,null, password, null);
    var db = new DatabaseHelper();
    var userRes = new UserModel(null,null, null,null,null, null, null);
    userRes = UserModel.map(await db.selectUser(user));
    if(userRes != null){
      _showSnackBar("Berhasi Login",context,Colors.green);
      GeneralSharedPreferences.writeObject("user_data", userRes.toMap());
      GeneralSharedPreferences.writeBool("is_login", true);
      Future.delayed(Duration(seconds: 2),(){
        Navigator.of(context).pushNamed("/home");
      });
    }else {
      _showSnackBar("Gagal Login",context,Colors.red);
    }
    // return user;
  }

}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
