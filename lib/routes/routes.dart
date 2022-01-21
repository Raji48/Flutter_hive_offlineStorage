import 'package:flutter/material.dart';
import 'package:offlinestorage/screens/feedscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/feed':
        return MaterialPageRoute(builder: (context) =>  FeedScreen());

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) =>   FeedScreen());
    }
  }
}