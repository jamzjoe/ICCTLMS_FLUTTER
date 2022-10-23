import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'package:icct_lms/api/class/Posts.dart';
import 'package:icct_lms/api/class/Show.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _messageController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _nameController = TextEditingController();
  Future createData (Map<String, String> data) async{

    _setHeaders()=>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer 2|URP3yGZlyi5G9qnlIFtlSROgAiOQL9MGFVSAm47Q'
    };
    final uri = Uri.parse('http://192.168.172.13:8000/api/posts');
    return await post(
        uri,
        body: jsonEncode(data),
        headers: _setHeaders(),
    );


  }
  var posts = <Posts>[];
  Future<Response> deletePost(int id) async {
    final Response response = await delete(
      Uri.parse('http://192.168.172.13:8000/api/posts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer '
            '2|URP3yGZlyi5G9qnlIFtlSROgAiOQL'
            '9MGFVSAm47Q'
      },
    );

    return response;
  }
  Future<List<Posts>> getData() async {
    final uri = Uri.parse('http://192.168.172'
        '.13:8000/api/posts/');
    Response response = await get(uri);
    Iterable data = json.decode(response.body);

    // (data as List<dynamic>).map((posts) => Posts.fromJson(posts)).toList();
    if(response.statusCode == 200){
      return posts = data.map((e) => Posts.fromJson(e)).toList();

    }else{
      throw Exception('Failed to load;');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(child:
                    Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Name'),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _userTypeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('User Type'),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _messageController,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Messages'),
                          ),
                        ),
                      ],
                    )
                    ),
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      var data = {
                        'name': _nameController.text.trim(),
                        'user_type': _userTypeController.text.trim(),
                        'messages': _messageController.text.trim()
                      };
                      createData(data);
                    });
                  }, child: const Text('Post')),
                  ...posts.map(buildTiles).toList()],
              );
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else
            {
                return Center(
                  child: Text('$snapshot.error'),
                );
            }

        }
      )


      // Column(
      //   children: [
      //     buildButton(
      //       title: 'Joe Cristian Jamis',
      //       icon: Icons.notifications,
      //       onClicked: () => NotificationApi.showNotification(
      //         title: 'Sarah Abs',
      //         body: 'Hey Joe',
      //         payload: 'sarah.abs'
      //       )
      //     )
      //   ],
      // )
    );
  }

  buildButton({required String title, required IconData icon, required Function() onClicked}) {}

  Widget buildTiles(Posts e) => ListTile(
    onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Show
          (name: e.name, usertype: e.user_type, messages: e.messages, id: e.id,
        )));
    },
    trailing: IconButton(onPressed: (){

      setState(() {
        deletePost(e.id);
      });
    }, icon: Icon(Icons.delete)),
    title: Text(e.name),
    leading: Text(e.user_type),
    subtitle: Text(e.messages),


  );
}
