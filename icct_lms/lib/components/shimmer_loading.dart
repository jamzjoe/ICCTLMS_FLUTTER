import 'package:flutter/material.dart';
import 'package:icct_lms/components/shimmer_widget.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerWidget.circular(height: 64,),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => buildLoadShimmer() ,
        ),
      ),
    );
  }

 Widget buildLoadShimmer() =>  const ListTile(
   leading: ShimmerWidget.circular(width: 64, height: 64,),
   title: ShimmerWidget.rectangular(height: 16),
   subtitle: ShimmerWidget.rectangular(height: 14),
 );
}
