import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:tpms/utils/EnvironmentUtil.dart';

import 'ui/home_page.dart';

void main() {
  if (EnvironmentUtil.isDebug()) {
    LogUtil.init(isDebug: true);
    runApp(MyApp());
  } else {
    FlutterBugly.postCatchedException(() {
      runApp(MyApp());
    });
    FlutterBugly.init(
        androidAppId: "0f9b7f38ed",
        iOSAppId: "51dfac0099",
        autoCheckUpgrade: false);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
