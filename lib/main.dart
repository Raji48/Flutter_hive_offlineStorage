/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() async{
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box box;
  List data = [];
  Future openBox() async{
  var dir =await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  box = await Hive.openBox('data');
  return;
  }

  getallData() async{
    await openBox();
    String url = "http://3.220.107.106:9000/feedback";

    try{
      print("try");
      // Map dat = {
      //   "userId": "6188d4d2ae61321400cd8a67",
      //   "roleType": "Customer"
      // };
       var response = await http.get(Uri.parse(url),
          // body: dat,
           headers: {
         'Authorization':
             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxODhkNGQyYWU2MTMyMTQwMGNkOGE2NyIsInJvbGUiOiJDdXN0b21lciIsImlhdCI6MTYzOTc0MjA5NiwiZXhwIjoxNjM5NzcwODk2fQ.mY0rDXFn-yV6wT6tUt85vwL-9BReMKyIouDwgeQ30Ss'
       }
       );
       print(response.statusCode);
       print(response.body);//(Uri.parse(url));
       var jsondecode = jsonDecode(response.body);
       print("jsondecode");
       await putData(jsondecode);
      print("data");
    }catch(e){
       print("Error");
       print(e);
    }

    //get the data from db
    var mymap = box.toMap().values.toList();
    if(mymap.isEmpty){
         data.add('empty');
    }else{
          data = mymap;
    }
    return Future.value(true);
  }

  Future putData(data)async{
    print("putdata");
    await box.clear();
    print("boxclear");
    for(var d in data){
       box.add(d);
       print("data added");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
   body: Center(
     child: FutureBuilder(
       future: getallData(),
       builder: (context, snapshot){
         if(snapshot.hasData){
            if(data.contains('empty')){
               return Text("No data");
            }else{
              return Column(
                children: [
                   ListView.builder(
                      itemCount: data.length ,
                       itemBuilder: (context, index){
                        return ListTile(
                          title: Text("title"),
                        );
                       })
                ],
              );
            }
         }else{
           return CircularProgressIndicator();
         }
     }
     ),
   )
    );
  }
}
*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:offlinestorage/ApiService/apimiddleware.dart';
import 'package:offlinestorage/actions/adaptor.dart';
import 'package:offlinestorage/models/app_state.dart';
import 'package:offlinestorage/reducer/feed_reducer.dart';
import 'package:offlinestorage/routes/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

const String SETTINGS_BOX = "settings";
const String API_BOX = "api_data";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
   Directory directory = await getApplicationDocumentsDirectory();
   Hive.init(directory.path);
   Hive.registerAdapter(ServiceAdapter());
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp> {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware, apiMiddleware, ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StoreProvider(
        store: this.store,
        child: MaterialApp(
          builder: (context, child) {
            return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child:child!);
          },
          navigatorKey: navigatorKey,
          initialRoute: '/feed',
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          //  home: Splash(),
        )
    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Hive.box(SETTINGS_BOX).get("welcome_shown"));
    return ValueListenableBuilder(
      valueListenable: Hive.box(SETTINGS_BOX).listenable(),
      builder: (context, dynamic box, child) =>
      box.get('welcome_shown', defaultValue: false)
          ? HomePage()
          : WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome Page"),
            ElevatedButton(
              onPressed: () async {
                var box = Hive.box(SETTINGS_BOX);
                box.put("welcome_shown", true);
              },
              child: Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Home page'),
      ),

      body: FutureBuilder(
        future: Apiservice().getposts(),
        builder: (context,dynamic snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          final List posts = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Text("This is a home page"),
              ...posts.map((e) => ListTile(
                title: Text(e['title']),
              )),
              ElevatedButton(
                onPressed: () {
                  Hive.box(SETTINGS_BOX).put('welcome_shown',false);
                },
                child: Text("Clear"),
              )
            ],
          );
        }
      ),
    );
  }
}

class Apiservice{
Future getposts() async{
  print("getposts");
  final posts = Hive.box(API_BOX).get('posts',defaultValue: []);
   if(posts.isNotEmpty) return posts;
   final url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
   final res = await http.get(url);
   print(res.body);
   final resjson = jsonDecode(res.body);
   Hive.box(API_BOX).put("posts", resjson);
   return resjson;
}
}*/