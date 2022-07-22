import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class Copy{
  Future showAndCopy(String text, String copyText,BuildContext context, bool
  mounted)
  async{
    await FlutterClipboard.copy(copyText);
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text
      (text),
      duration: const
      Duration
        (milliseconds:
      1000), ), );
  }
}