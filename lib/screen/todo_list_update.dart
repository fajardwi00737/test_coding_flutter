import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:date_format/date_format.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_live_code/model/catatan_model.dart';
import 'package:test_live_code/screen/widget/custom_button_primary.dart';
import 'package:test_live_code/utils/database_helper.dart';
import 'package:test_live_code/utils/flushbar_notif.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

class TodoListUpdate extends StatefulWidget {
  final Map<String, dynamic> catatanData;
  final int type;
  TodoListUpdate({this.catatanData,this.type});
  @override
  _TodoListUpdateState createState() => _TodoListUpdateState();
}

class _TodoListUpdateState extends State<TodoListUpdate> {
  TextEditingController _setDateController = new TextEditingController();
  TextEditingController _setTimeController = new TextEditingController();
  TextEditingController textEditingControllerJudul = TextEditingController();
  TextEditingController textEditingControllerDeskripsi = TextEditingController();
  bool isPengingat = false;
  double _kPickerSheetHeight = 216.0;
  String _interval,_fotoCatatan,judulCatatan,deskripsiCatatan;
  Uint8List imgBase64;
  CatatanModel catatanModel;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _date = '';
  String _time = '';

  String _hours = '';
  String _minutes = '';

  String _dateLayout = '';

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

  @override
  void initState() {
    // TODO: implement initState
    initData();
    super.initState();
  }

  initData()async{
    if(widget.type == 1){
      print("add data");
    } else {
      print(widget.catatanData["judul"]);
      print(widget.catatanData["deskripsi"]);
      print(widget.catatanData["waktuPengingat"]);
      print(widget.catatanData["intervalPengingat"]);
      setState(() {
        textEditingControllerJudul.text = widget.catatanData["judul"];
        textEditingControllerDeskripsi.text = widget.catatanData["deskripsi"];
        _interval = widget.catatanData["intervalPengingat"];
        _setTimeController.text = widget.catatanData["waktuPengingat"];
        _fotoCatatan = widget.catatanData["lampiran"];
        if(_fotoCatatan == null){
          imgBase64 = null;
        } else {
          imgBase64 = Base64Decoder().convert(widget.catatanData["lampiran"]);
        }

      });
    }
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
          _fotoCatatan = base64string;
        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }

  _setTimePicker() {
    DateTime initialDateTime = DateTime.now();
    showCupertinoModalPopup<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return _buildBottomPicker(CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              minuteInterval: 1,
              use24hFormat: true,
              initialDateTime: DateTime(
                  initialDateTime.year,
                  initialDateTime.month,
                  initialDateTime.day,
                  initialDateTime.hour,
                  initialDateTime.minute),
              onDateTimeChanged: (DateTime newDataTime) {
                if (mounted) {
                  setState(() {
                    print("time selected => " + newDataTime.toString());
                    _hours = newDataTime.hour.toString().padLeft(2, '0');
                    _minutes = newDataTime.minute.toString().padLeft(2, '0');
                    _time = _hours + ':' + _minutes;
                    _setTimeController.text = _time;
                  });
                  print("time picked => " + _setTimeController.text.toString());
                  print("time picked => " + _time.toString());
                }
              }));
        });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: SafeArea(
                  top: false,
                  child: picker,
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Selesai",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ))),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.type == 1 ? "Tambah Catatan" : "Edit Catatan"),
        centerTitle: true,
        actions: [
          Visibility(
            visible: widget.type == 1 ? false : true,
            child: IconButton(icon: Icon(Icons.delete_rounded,color: Colors.white,), onPressed: (){
              deleteCatatan();
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 16,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: textEditingControllerJudul,
                  decoration: InputDecoration(
                    hintText: "Masukkan Judul",
                  ),
                  onChanged: (val) => judulCatatan = val,
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
                  controller: textEditingControllerDeskripsi,
                  decoration: InputDecoration(
                    hintText: "Masukkan Deskripsi",
                  ),
                  onChanged: (val) => deskripsiCatatan = val,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Waktu Pengingat",style: TextStyle(fontSize: 17),),
                    Switch(value: isPengingat, onChanged: (bool){
                      setState(() {
                        isPengingat = bool;
                        if(!bool){
                          _setTimeController.clear();
                        }
                      });
                    }),
                  ],
                ),
              ),
              Visibility(
                visible: isPengingat,
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 32),
                  //color: Colors.deepPurple,
                  alignment: Alignment.topLeft,
                  child: Text(
                    'JAM',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
              ),
              Visibility(
                visible: isPengingat,
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  alignment: Alignment.topLeft,
                  child: TextFormField(
                    readOnly: true,
                    onTap: _setTimePicker,
                    controller: _setTimeController,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,),
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: 'Set jam',
                      hintStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      hoverColor: Colors.red,
                      focusColor: Colors.red,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    validator: (value) {
                      if(isPengingat){
                        if (value == null || value.isEmpty) {
                          return 'Waktu tidak boleh kosong';
                        }
                      } else {
                        return null;
                      }
                      return null;
                    },
                  ),
                ),
              ),

              Visibility(
                visible: isPengingat,
                child: Column(
                  children: [
                    SizedBox(height: 16,),
                    Container(
                        margin: EdgeInsets.only(left: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Text("Interval pengingat :",style: TextStyle(fontSize: 17),)),
                    SizedBox(height: 8,),
                    RadioListTile(
                      title: Text("Tidak ada"),
                      value: "Tidak ada",
                      groupValue: _interval,
                      onChanged: (value){
                        setState(() {
                          // jenisKelamin = value.toString();
                          _interval = value.toString();
                        });
                      },
                    ),

                    RadioListTile(
                      title: Text("5 jam sebelumnya"),
                      value: "5 jam sebelumnya",
                      groupValue: _interval,
                      onChanged: (value){
                        setState(() {
                          // jenisKelamin = value.toString();
                          _interval = value.toString();
                        });
                      },
                    ),

                    RadioListTile(
                      title: Text("3 jam sebelumnya"),
                      value: "3 jam sebelumnya",
                      groupValue: _interval,
                      onChanged: (value){
                        setState(() {
                          // jenisKelamin = value.toString();
                          _interval = value.toString();
                        });
                      },
                    ),

                    RadioListTile(
                      title: Text("1 jam sebelumnya"),
                      value: "1 jam sebelumnya",
                      groupValue: _interval,
                      onChanged: (value){
                        setState(() {
                          // jenisKelamin = value.toString();
                          _interval = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Text("Lampiran",style: TextStyle(fontSize: 17),)),
              SizedBox(height: 16,),
              Container(
                child: Stack(
                  children: [
                    Container(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                            borderRadius:BorderRadius.circular(1),
                            child: imgBase64 == null ? Container(
                              color: Colors.grey,
                            ):new Image.memory(imgBase64,fit: BoxFit.cover,))),
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
                  title: "Simpan".toUpperCase(),
                  customTextSize: 12,
                  textColor: Colors.white ,
                  isEnable: true,
                  btnLoading: false,
                  onTap: (){
                    // logout(context);
                    // _isTypeSelected(1);
                    // logout();
                    actionSave();
                  },
                  borderRadius: 50,
                ),
              ),
              SizedBox(height: 32,),
            ],
          ),
        ),
      ),
    );
  }

  actionSave(){
    print(judulCatatan);
    print(deskripsiCatatan);
    print("masa gak ada si");
    if(widget.type == 1){
      if(isPengingat){
        if(_interval != null){
          saveCatatan();
        } else {
          _showSnackBar("Form harus diisi semua",context,Colors.red);
        }
      } else {
        setState(() {
          _interval = "-";
        });
        saveCatatan();
      }
    } else {
      if(isPengingat){
        if(_interval != null){
          if(_interval != "-"){
            print(_interval);
            print("interval tidak null");
            if(_setTimeController.text != null){
              if(_setTimeController.text.isNotEmpty){
                print(_setTimeController.text);
                print("time tidak null");
                updateCatatan();
              } else {
                print(_setTimeController.text);
                print("time null");
                _showSnackBar("Form harus diisi semua",context,Colors.red);
              }

            } else {
              print(_setTimeController.text);
              print("time null");
              _showSnackBar("Form harus diisi semua",context,Colors.red);
            }
          } else{
            print(_setTimeController.text);
            print("time null");
            _showSnackBar("Form harus diisi semua",context,Colors.red);
          }


        } else {
          print(_interval);
          print("interval null");
          _showSnackBar("Form harus diisi semua",context,Colors.red);
        }
      } else {
        setState(() {
          _interval = "-";
        });
        updateCatatan();
      }
    }
  }

  void _showSnackBar(String text,BuildContext context,Color colorBacground) {
    FlushbarNotif.flushbarTop(context, FlushbarPosition.TOP, text, Colors.white, colorBacground);
  }

  saveCatatan()async{
    var catatan = new CatatanModel(null, textEditingControllerJudul.text, textEditingControllerDeskripsi.text, _setTimeController.text, _interval, _fotoCatatan);
    var db = new DatabaseHelper();
    int res = await db.saveCatatan(catatan);
    if (res != null){
      _showSnackBar("Berhasi Simpan Catatan",context,Colors.green);
      Future.delayed(Duration(seconds: 2),(){
        Navigator.of(context).pushNamed("/todo_list_page");
       // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeNavigation()));
      });
    } else {
      _showSnackBar("Gagal Simpan Catatan",context,Colors.red);
    }
    // isLoading = false;
  }

  deleteCatatan()async{
    var db = new DatabaseHelper();
    CatatanModel dataCatatan = CatatanModel( widget.catatanData["id"],  widget.catatanData["judul"],  widget.catatanData["deskripsi"],  widget.catatanData["waktuPengingat"],  widget.catatanData["intervalPengingat"],  widget.catatanData["lampiran"]);
    int res = await db.deleteCatatan(dataCatatan);
    if (res != null){
      _showSnackBar("Berhasi delete Catatan",context,Colors.green);
      Future.delayed(Duration(seconds: 2),(){
        Navigator.of(context).pushNamed("/home");
      });
    } else {
      _showSnackBar("Gagal delete Catatan",context,Colors.red);
    }
  }

  updateCatatan()async{
    var catatan = new CatatanModel(widget.catatanData["id"], textEditingControllerJudul.text, textEditingControllerDeskripsi.text, _setTimeController.text, _interval, _fotoCatatan);
    var db = new DatabaseHelper();
    var catatanRes = new CatatanModel(null, null, null, null, null, null);
    catatanRes = CatatanModel.map(await db.updateCatatan(catatan));
    // print(catatanRes.namaDepan);
    if(catatanRes != null){
      _showSnackBar("Berhasi Update data",context,Colors.green);
      GeneralSharedPreferences.writeObject("user_data", catatanRes.toMap());
      Future.delayed(Duration(milliseconds: 300),(){
        Navigator.of(context).pushNamed("/todo_list_page");
      });
    }else {
      _showSnackBar("Gagal update data",context,Colors.red);
    }
  }
}
