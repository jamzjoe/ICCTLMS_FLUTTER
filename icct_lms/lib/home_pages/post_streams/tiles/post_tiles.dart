import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/home_streams/comment_count_stream.dart';
import 'package:icct_lms/home_pages/home_streams/heart_stream.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Widget createTiles({required PostModel e, required BuildContext context,
  required HomeScreen
widget}) =>
    InkWell(
  onTap: () async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Comment(
                e: e,
                username: widget.userName,
                userType: widget.userType,
                userID: widget.uid)));
  },
  child: Card(
    child: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: e.userType == "Teacher"
                ? Colors.blue[900]
                : Colors.redAccent,
            child: Center(
              child: Text(
                e.postName.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(text: e.postName),
                        const TextSpan(
                            text: ' posted from ',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        TextSpan(
                            text: e.roomName,
                            recognizer: TapGestureRecognizer()..onTap = () {})
                      ])),
              Text(
                e.userType,
                style: const TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 12),
              ),
              Text(
                '${e.date} ${e.hour}',
                style: const TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 12),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableLinkify(
                  options: const LinkifyOptions(humanize: true),
                  text: e.message,
                  onOpen: (link) async {
                    launch(link.url);
                  },
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                  linkStyle: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeHeartStreams(widget: widget, e: e),
              HomeCommentCountStreams(widget: widget, e: e),
              Flexible(
                child: IconButton(
                  onPressed: () {
                    share(e.message, e.postName);
                  },
                  icon: const Icon(FontAwesomeIcons.shareNodes),
                  color: Colors.grey,
                ),
              )
            ],
          ),
        )
      ],
    ),
  ),
);

Future share(String message, String name) async {
  await Share.share('Post from $name \n $message');
}