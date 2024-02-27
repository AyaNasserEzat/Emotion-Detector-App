import 'package:camera/camera.dart';
import 'package:emotion_detector/splash_screen.dart';
import 'package:flutter/material.dart';
List<CameraDescription>? cameres;
void main() async{
      WidgetsFlutterBinding.ensureInitialized();
  cameres=await availableCameras();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
