
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:offlinestorage/ApiService/constants.dart';
import 'package:offlinestorage/actions/feedactions.dart';
import 'package:offlinestorage/models/app_state.dart';
import 'package:offlinestorage/models/feed_model.dart';
import 'package:offlinestorage/models/hivemodel.dart';
import 'package:offlinestorage/screens/Updatedata.dart';
import 'package:redux/redux.dart';

const String SETTINGS_BOX = "settings";
const String API_BOX = "api_data";

  class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

List<GetService>ListServiceItems = [];
var box;

class _FeedScreenState extends State<FeedScreen> {
  int listLenght = 0;

  //@override
  void initState(){
    hiveopen();
  }

  hiveopen() async {
     box = await Hive.openBox<GetService>('service');

    setState(() {
      ListServiceItems = box.values.toList();
    });

    print("DB init lenght" );
    print(ListServiceItems.length);
    // await Hive.initFlutter();
   // await Hive.openBox(SETTINGS_BOX);
   // await Hive.openBox(API_BOX);
    //await Hive.openBox(ITEMS_BOX);
    //final box = await Hive.openBox<Service>('service');

   /* GetService adddata = new GetService(
        name: "nameee",
        status: "Accepted",
        lastname: "lastnameis");
    var box = await Hive.openBox<GetService>('student');

    box.clear();
    box.add(adddata);
   // box.put('student', adddata);
   //print(box.values);
    getdata();*/
  }

  void  getdata() async {
    // GetService addata = new GetService(
    //     name: "secondname",
    //     status: "isAccepted",
    //     lastname: "slastnameis");

     box = await Hive.openBox<GetService>('service');

    //box.add(addata);

    setState(() {
      ListServiceItems = box.values.toList();
    });

    print(ListServiceItems.length);
    print(ListServiceItems.first.status);
    print(ListServiceItems.last.status);
  }

  putalldata(RequestProps props) async {
     box = await Hive.openBox<GetService>('service');
    box.clear();
    //print("successstate");

    print(props.feedsuccess!.success!.length);

    for(int i=0; i<listLenght; i++) {
      GetService adddata = new GetService(
          name: props.feedsuccess!.success![i].waiterId!.firstName.toString(),
          status: props.feedsuccess!.success![i].status.toString(),
          lastname: props.feedsuccess!.success![i].waiterId!.lastName.toString());
          box.add(adddata);
    }

    setState(() {
      ListServiceItems = box.values.toList();
    });

    print("DB store lenght" );
    print(ListServiceItems.length);
    //getdata();
  }

  var data = {
    "userId":userid.toString()
  };

   void handleInitialBuild(RequestProps props) {
     props.feedsuccessapi("");
   }

  //@override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RequestProps>(
    converter: (store) => mapStateToProps(store),
    onInitialBuild: (props) => this.handleInitialBuild(props),
    builder: (context, props) {

    if (props.loading == true) {
      print("loading");
    }

    else if(props.feedsuccess != null) {
       print("success");
        //putalldata(props);
       listLenght =  props.feedsuccess!.success!.length;
       Timer(Duration(milliseconds: 100), () {
         putalldata(props);
         //props.clearpropsreq("true");
       });
       props.clearpropsreq("true");
    }

    else if(props.error != null){
       print("error");
       props.clearpropsreq("true");
    }

    return Scaffold(
        appBar: AppBar(
        title: Text('Home page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateData( getServicemodel: null, position: -1, isEdit:false,)));
              },
            )
          ],
    ),

      body:
    ListView.builder(
    itemCount: ListServiceItems.length,
    itemBuilder: (context, position) {
      GetService getdeatils = ListServiceItems[position];
      var name = getdeatils.name;
      var status = getdeatils.status;
      var lastname = getdeatils.lastname;
      return Card(
          child: Container(
          padding: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text( "USER NAME : "+name + " "+ lastname, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("STATUS MESSAGE : "+ status),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Container(
                //   child: IconButton(
                //       icon: Icon(Icons.add,color: Colors.black,),
                //       onPressed: () {
                //         // Navigator.push(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //         builder: (_) => UpdateData(
                //         //               isEdit: true,position: position, getServicemodel:getdeatils,)));
                //       }),
                // ),

                Container(
                  child: IconButton(
                      icon: Icon(Icons.edit,color: Colors.blue,),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UpdateData(
                                      isEdit: true,position: position, getServicemodel:getdeatils,)));
                      }),
                ),

                IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: (){
                      final box = Hive.box<GetService>('service');
                      box.deleteAt(position);
                      setState(() => {
                        ListServiceItems.removeAt(position)
                      });
                    })
              ],
            )
          ],
        )
          )
      );
    })

      /* ListView.builder(
        itemCount: 5,//Hive.box(ITEMS_BOX).values.length,//props.feedsuccess!.success!.length,
        itemBuilder: (context, index ) {
          print("Status");
          return ListTile(
              title: Text( "Hive.box(API_BOX).values.toList().toString()") //Hive.box(ITEMS_BOX).toMap().values.toString())//"Status : "+ Hive.box(API_BOX).get('status',defaultValue: [])),
            //subtitle: Text("Name : "+Hive.box(API_BOX).get('listnames',defaultValue: [])),
          );
        })*/

    );
    });
  }
}



// This code for Store details in Hive from API response without using Redux
// class Apiservice{
//   Future getposts() async{
//     print("getposts");
//    // final posts = Hive.box(API_BOX).get('posts',defaultValue: []);
//     //if(posts.isNotEmpty) return posts;
//     final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
//     final res = await http.get(url);
//     final resjson = jsonDecode(res.body);
//     Hive.box(API_BOX).put("posts", resjson);
//     return resjson;
//   }
// }


class RequestProps {
  final bool? loading;
  final dynamic error;
  final FeedModel? feedsuccess;
  final Function feedsuccessapi;
  final Function clearpropsreq;

  RequestProps({
    this.loading,
    this.error,
    this.feedsuccess,
    required this.feedsuccessapi,
    required this.clearpropsreq,
  });
}

RequestProps mapStateToProps(Store<AppState> store) {
  return RequestProps(
      loading: store.state.feed.loading,
      error: store.state.feed.error,
      feedsuccess: store.state.feed.feed,
      feedsuccessapi: (data)=>store.dispatch(feedaction(data)),
      clearpropsreq: (data) => store.dispatch(clearpropsviewrequest(data)),
  );
}