import 'package:flutter/material.dart';
import 'package:test_live_code/screen/todo_list_update.dart';
import 'package:test_live_code/utils/database_helper.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  List<Map<String, dynamic>> catatanRes = [];
  @override

  void initState() {
    // TODO: implement initState
    setDataListCatatan();
    super.initState();
  }


  setDataListCatatan()async{
    var db = new DatabaseHelper();
    List<Map<String, dynamic>> catatanData;
    catatanData = await db.selectCatatan(GeneralSharedPreferences.readInt("user_id"));
    setState(() {
      catatanRes = catatanData;
    });
    if(catatanRes != null){
      print(catatanRes);
    } else {
      print("tidak ada catatan");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Catatan"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoListUpdate(type: 1,)));
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: catatanRes == null? Container(
          margin: EdgeInsets.only(top: 16),
          alignment: Alignment.topCenter,
          child: Text("Belum ada data",style: TextStyle(fontSize: 17),),
        ):ListView.builder(
            itemCount: catatanRes.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoListUpdate(type: 2,catatanData: catatanRes[index],)));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16,right: 16,bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(flex:1,child: Container(margin: EdgeInsets.only(top: 8),child: Text("Judul",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)))),
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(8),
                                  color: Colors.grey.withOpacity(0.2)
                              ),
                              child: Text(catatanRes[index]['judul']??"-",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(flex:1,child: Container(margin: EdgeInsets.only(top: 8),child: Text("Deskripsi",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)))),
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(8),
                                  color: Colors.grey.withOpacity(0.2)
                              ),
                              child: Text(catatanRes[index]['deskripsi']??"-",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Container(child: Text("Waktu",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)))),
                          Flexible(child: Container(child: Text(catatanRes[index]['waktuPengingat']??"-",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold))))
                        ],
                      ),
                      SizedBox(height: 16,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Container(child: Text("Interval",style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold)))),
                          Flexible(child: Container(child: Text(catatanRes[index]['intervalPengingat']??"-",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color: Colors.black,fontSize:12,fontWeight: FontWeight.bold))))
                        ],
                      ),
                      // Text(catatanRes[index]['judul'],style: TextStyle(fontSize: 17,color: Colors.black),),
                    ],
                  ),
                ),
              );
            }
        ),
      )
    );
  }
}
