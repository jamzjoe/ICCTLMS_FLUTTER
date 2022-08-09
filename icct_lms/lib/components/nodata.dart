import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key, required this.noDataText}) : super(key: key);
  final String noDataText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/no_room.json', width: 200),
          Text(
            noDataText,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
