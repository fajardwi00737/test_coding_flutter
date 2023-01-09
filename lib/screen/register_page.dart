import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_live_code/model/user_model.dart';
import 'package:test_live_code/screen/widget/custom_button_primary.dart';
import 'package:test_live_code/utils/database_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test_live_code/utils/flushbar_notif.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String gender, namaDepan,namaBelakang,email,tanggalLahir,jenisKelamin,password,_fotoProfile;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool isLoading = false,showPassword  = true;

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

  openImage() async {
    try {
      var pickedFile = await imgpicker.getImage(source: ImageSource.gallery);
      if(pickedFile != null){
        imagepath = pickedFile.path;
        print(imagepath);

        File imagefile = File(imagepath);
        Uint8List imagebytes = await imagefile.readAsBytes();
        String base64string = base64.encode(imagebytes);
        print(base64string);


        setState(() {
          _fotoProfile = base64string;
        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32,),
                  Container(
                    child: Stack(
                      children: [
                        imagepath != ""?
                        Container(
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                              borderRadius:BorderRadius.circular(100),
                                child: Image.file(File(imagepath),fit: BoxFit.cover,))): Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle
                          ),
                          child: Icon(Icons.person,size: 50,color: Colors.white,),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: (){
                              openImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                boxShadow: [BoxShadow(
                                  color: Colors.grey.shade400,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0.5,0.5)
                                )]
                              ),
                              child: Icon(Icons.camera_alt_outlined,size: 20,color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Depan",
                      ),
                      onSaved: (val) => namaDepan = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama depan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Belakang",
                      ),
                      onSaved: (val) => namaBelakang = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama belakang tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Masukkan Email",
                      ),
                      onSaved: (val) => email = val,
                      validator: (val) => val == null || val.isEmpty ? "Email tidak boleh kosong": val.isValidEmail() ? null : "Format email salah",
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Masukkan Tanggal Lahir",
                      ),
                      onSaved: (val) => tanggalLahir = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Text("Jenis Kelamin :",style: TextStyle(fontSize: 17),)),
                  SizedBox(height: 8,),
                  RadioListTile(
                    title: Text("Laki-laki"),
                    value: "Laki-laki",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        jenisKelamin = value.toString();
                        gender = value.toString();
                      });
                    },
                  ),

                  RadioListTile(
                    title: Text("Perempuan"),
                    value: "Perempuan",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        jenisKelamin = value.toString();
                        gender = value.toString();
                      });
                    },
                  ),
                  SizedBox(height: 8,),
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
                      onSaved: (val) => password = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 32,),
                  Container(
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomButtonPrimary(
                      color: Colors.blue,
                      hasWidth: true,
                      hasHeight: true,
                      isBorder: false,
                      title: "Register".toUpperCase(),
                      customTextSize: 12,
                      textColor: Colors.white ,
                      isEnable: true,
                      btnLoading: false,
                      onTap: (){
                        // logout(context);
                        // _isTypeSelected(1);
                        _submit(context);
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

  void _showSnackBar(String text,BuildContext context,Color colorBacground) {
    FlushbarNotif.flushbarTop(context, FlushbarPosition.TOP, text, Colors.white, colorBacground);
  }

  void _submit(BuildContext context){
    print(_fotoProfile);
    final form = formKey.currentState;

    if (form.validate()) {
      if(_fotoProfile != null && jenisKelamin != null){
        setState(() {
          isLoading = true;
          form.save();
          saveRegis();


        });
      } else {
        _showSnackBar("Form harus diisi semua",context,Colors.red);
      }
    }
  }

  saveRegis()async{
    var user = new UserModel(namaDepan, namaBelakang,email,tanggalLahir,jenisKelamin, password, _fotoProfile);
    var db = new DatabaseHelper();
    int res = await db.saveUser(user);
    if (res != null){
      _showSnackBar("Berhasi Registrasi",context,Colors.green);
        Future.delayed(Duration(seconds: 2),(){
          Navigator.of(context).pushNamed("/login");
      });
    } else {
      _showSnackBar("Email sudah digunakan",context,Colors.red);
    }
    isLoading = false;
  }
}
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
