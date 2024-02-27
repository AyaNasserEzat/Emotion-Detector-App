import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'package:tensorflow_lite_flutter/tensorflow_lite_flutter.dart';

class EmotionDetctor extends StatefulWidget {
  const EmotionDetctor({super.key});

  @override
  State<EmotionDetctor> createState() => _EmotionDetctorState();
}

class _EmotionDetctorState extends State<EmotionDetctor> {
  CameraController? cameraController;
  String output = '';
  double percent = 0;
  loadCamera() {
    cameraController = CameraController(cameres![0], ResolutionPreset.max);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((image) {
            runModel(image);
          });
        });
      }
    });
  }

  runModel(CameraImage? img) async {
    if (img != null) {
      var recognitions = await Tflite.runModelOnFrame(
          bytesList: img.planes.map((plane) {
            return plane.bytes;
          }).toList(), // required
          imageHeight: img.height,
          imageWidth: img.width,
          imageMean: 127.5, // defaults to 127.5
          imageStd: 127.5, // defaults to 127.5
          rotation: 90, // defaults to 90, Android only
          numResults: 2, // defaults to 5
          threshold: 0.1, // defaults to 0.1
          asynch: true // defaults to true
          );
      for (var element in recognitions!) {
        setState(() {
          output = element['label'];
          percent = element['confidence'];
          percent *= 100;
        });
      }
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      labels: 'assets/model/labels.txt',
      model: 'assets/model/model_unquant.tflite',
    );
  }

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Emotion Detector',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.6,
              width:  MediaQuery.of(context).size.width,
              child: 
                !cameraController!.value.isInitialized
                    ? Container()
                    : ClipRRect(
                borderRadius: BorderRadius.circular(20),child:  CameraPreview(cameraController!),
                    ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              '$output %${(percent).toInt()}',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            Text(
              'Don\'t forget to contact me on social media',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Center(
                
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    contacts(
                      url: "https://www.linkedin.com/in/aya-nasser-189578223",
                      image: "assets/images/linkedin.png",
                    ),
                     contacts(
                      url: "https://wa.me/qr/TTVZ2QYXVN5HK",
                      image: "assets/images/whatsapp.png",
                    ),
                     contacts(
                      url: "https://www.facebook.com/profile.php?id=100062573323303&mibextid=ZbWKwL",
                      image: "assets/images/facebook.png",
                    ),
                    
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class contacts extends StatelessWidget {
  contacts({
    this.image,
    this.url,
    super.key,
  });
  String? image;
  String? url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(url!));
      },
      child: CircleAvatar(
        backgroundImage: AssetImage(image!),
      ),
    );
  }
}
