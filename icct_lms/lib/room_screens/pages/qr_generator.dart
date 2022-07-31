import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/qr_loading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key, required this.roomCode, required this.teacherUID}) : super(key: key);
  final String roomCode;
  final String teacherUID;
  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

final screenShotController = ScreenshotController();
class _QrGeneratorState extends State<QrGenerator> {

  bool isLoading = true;
  Future load()async{
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenShotController,
      child:
          isLoading ?  const QRloading(loadingText: 'Generating QR Code',) :
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('Generate QR Code'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              buildQrImage(widget.teacherUID, widget.roomCode),
              const SizedBox(
                width: 250,
                child: Text('Share or capture this generated QR Code image to '
                    'your student.', textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 120,
                child: ElevatedButton.icon(onPressed: ()async{
                  final image = await screenShotController.captureFromWidget
                  (buildQrImage
                    (widget.teacherUID,
                      widget.roomCode));

                  if(image == null) return;

                  await saveImage(image);

                }, label: const Text
                  ('Capture'), icon: const Icon(Icons.camera), style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900]
                ),),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton.icon(onPressed: ()async{
                  final image = await screenShotController.captureFromWidget
                    (buildQrImage
                    (widget.teacherUID,
                      widget.roomCode));
                  share(image);
                }, label: const Text
                    ('Share'), icon: const Icon(Icons.share),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900]
                  ),),
              )
            ],
          ),

        ),
      ),
    );
  }

  Widget buildQrImage(String teacherUID, String roomCode) =>  QrImage(
    data: '$roomCode,$teacherUID',
    eyeStyle: QrEyeStyle(
      eyeShape: QrEyeShape.square,
      color: Colors.blue[900]
    ),
    size: 200,
    backgroundColor: Colors.white,);

  Future<String> saveImage(Uint8List bytes) async{
    await [Permission.storage].request();
    final result = await ImageGallerySaver.saveImage(bytes, name: widget.roomCode);
    return result['filePath'];
  }


  Future share(Uint8List bytes) async{
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);

    await Share.shareFiles([image.path]);
  }
}
