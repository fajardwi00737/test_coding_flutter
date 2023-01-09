import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_live_code/model/user_model.dart';
import 'package:test_live_code/screen/widget/custom_button_primary.dart';
import 'package:test_live_code/utils/database_helper.dart';
import 'package:test_live_code/utils/flushbar_notif.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String gender;
  bool isEdit = false,isSaveEdit = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  UserModel userModel;
  TextEditingController textEditingControllerND = new TextEditingController();
  TextEditingController textEditingControllerNB = new TextEditingController();
  TextEditingController textEditingControllerEmail = new TextEditingController();
  TextEditingController textEditingControllerTL = new TextEditingController();
  TextEditingController textEditingControllerJK = new TextEditingController();
  TextEditingController textEditingControllerPass = new TextEditingController();
  Uint8List imgBase64;
  String imagepath = "",_fotoProfile;
  final ImagePicker imgpicker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    initData();
    super.initState();
  }

  initData()async{
    userModel = UserModel.map(await GeneralSharedPreferences.readObject("user_data"));
    print(userModel.email);
    print(userModel.password);
    print(userModel.fotoProfil);
    print(userModel.jenisKelamin);
    setState(() {
      textEditingControllerND.text = userModel.namaDepan;
      textEditingControllerNB.text = userModel.namaBelakang;
      textEditingControllerEmail.text = userModel.email;
      textEditingControllerTL.text = userModel.tanggalLahir;
      textEditingControllerJK.text = userModel.jenisKelamin;
      textEditingControllerPass.text = userModel.password;
      _fotoProfile = userModel.fotoProfil;
      imgBase64 = Base64Decoder().convert(userModel.fotoProfil);
    });
  }

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
          imgBase64 = Base64Decoder().convert(base64string);
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
                  SizedBox(height: 16,),
                  Visibility(
                    visible: isEdit ? true : false,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                isEdit = false;
                              });
                              initData();
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
                              child: Icon(Icons.close,size: 20,color: Colors.black,),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                isEdit = false;
                              });
                              saveEditData();
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
                              child: Icon(Icons.check_rounded,size: 20,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isEdit ? false : true,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            isEdit = true;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
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
                          child: Icon(Icons.edit_rounded,size: 20,color: Colors.black,),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32,),
                  Container(
                    child: Stack(
                      children: [
                        Container(
                            height: 150,
                            width: 150,
                            child: ClipRRect(
                                borderRadius:BorderRadius.circular(1),
                                child: imgBase64 == null ? Container():new Image.memory(imgBase64,fit: BoxFit.cover,))),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: (){
                              if(isEdit){
                                openImage();
                              } else {
                                ///cannot do
                              }
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
                      readOnly: !isEdit,
                      controller: textEditingControllerND,
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Depan",
                      ),
                      onSaved: (val) => textEditingControllerND.text = val,
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
                      readOnly: !isEdit,
                      controller: textEditingControllerNB,
                      decoration: InputDecoration(
                        hintText: "Masukkan Nama Belakang",
                      ),
                      onSaved: (val) => textEditingControllerNB.text = val,
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
                      readOnly: !isEdit,
                      controller: textEditingControllerEmail,
                      decoration: InputDecoration(
                        hintText: "Masukkan Email",
                      ),
                      onSaved: (val) => textEditingControllerEmail.text = val,
                      validator: (val) => val == null || val.isEmpty ? "Email tidak boleh kosong": val.isValidEmails() ? null : "Format email salah",
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      readOnly: !isEdit,
                      controller: textEditingControllerTL,
                      decoration: InputDecoration(
                        hintText: "Masukkan Tanggal Lahir",
                      ),
                      onSaved: (val) => textEditingControllerTL.text = val,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  Visibility(
                    visible: isEdit ? false : true,
                    child: Column(
                      children: [
                        SizedBox(height: 16,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            readOnly: !isEdit,
                            controller: textEditingControllerJK,
                            decoration: InputDecoration(
                              hintText: "Masukkan Jenis Kelamin",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isEdit ? true : false,
                    child: Column(
                      children: [
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
                              textEditingControllerJK.text = value.toString();
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
                              textEditingControllerJK.text = value.toString();
                              gender = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      obscureText: true,
                      readOnly: !isEdit,
                      controller: textEditingControllerPass,
                      decoration: InputDecoration(
                        hintText: "Masukkan Password",
                      ),
                      onSaved: (val) => textEditingControllerPass.text = val,
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
                      title: "Logout".toUpperCase(),
                      customTextSize: 12,
                      textColor: Colors.white ,
                      isEnable: true,
                      btnLoading: false,
                      onTap: (){
                        // logout(context);
                        // _isTypeSelected(1);
                        logout();
                      },
                      borderRadius: 50,
                    ),
                  ),
                  SizedBox(height: 32,),
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

  logout()async{
      await GeneralSharedPreferences.remove("user_id");
      await GeneralSharedPreferences.remove("is_login");
      await GeneralSharedPreferences.remove("user_data");
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);

  }

  saveEditData()async{
    var user = new UserModel(textEditingControllerND.text, textEditingControllerNB.text,textEditingControllerEmail.text,textEditingControllerTL.text,textEditingControllerJK.text, textEditingControllerPass.text, _fotoProfile);
    var db = new DatabaseHelper();
    var userRes = new UserModel(null,null, null,null,null, null, null);
    userRes = UserModel.map(await db.updateUser(user));
    print(userRes.namaDepan);
    if(userRes != null){
      _showSnackBar("Berhasi Update data",context,Colors.green);
      GeneralSharedPreferences.writeObject("user_data", userRes.toMap());
      Future.delayed(Duration(milliseconds: 300),(){
      //   Navigator.of(context).pushNamed("/home");
        initData();
      });
      // return new Future.value(new UserModel(null, username, password,flagLogged));
    }else {
      _showSnackBar("Gagal update data",context,Colors.red);
      // return new Future.value(new UserModel(null, username, password,flagLogged));
    }
  }
}

extension EmailValidator on String {
  bool isValidEmails() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}