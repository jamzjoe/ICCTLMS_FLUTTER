import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Help Center'),
      ),
      body: const NoData(noDataText: 'No data yet...',),
    );
  }
}
