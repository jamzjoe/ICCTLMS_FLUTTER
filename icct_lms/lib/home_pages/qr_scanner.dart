import 'package:flutter/material.dart';
import 'package:icct_lms/components/qr_loading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}



class _QRScannerState extends State<QRScanner> {


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
    load();
    super.initState();
  }

  MobileScannerController cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return isLoading ?  const QRloading(loadingText: 'Loading QR Scanner',) :
    Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('QR Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors
                          .grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async{
              Navigator.of(context).pop(barcode.rawValue!);
              // if (barcode.rawValue == null) {
              //   debugPrint('Failed to scan Barcode');
              // } else {
              //   final String code = barcode.rawValue!;
              //   debugPrint('Barcode found! $code');
              // }
            }));
  }
}
