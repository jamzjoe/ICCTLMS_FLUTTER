import 'package:flutter/material.dart';
import 'package:icct_lms/components/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Shimmer.fromColors(
              highlightColor: Colors.white,
              enabled: true,
              baseColor: Colors.grey,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white60
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => buildLoadShimmer() ,
                ),
              ),
            ),
          ],
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
