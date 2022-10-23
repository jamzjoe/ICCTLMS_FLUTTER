import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Show extends StatefulWidget {
  const Show({Key? key, required this.name, required this.usertype, required this.messages, required this.id}) : super(key: key);
  final String name;
  final String usertype;
  final String messages;
  final int id;
  @override
  State<Show> createState() => _ShowState();
}

final _apiMessageController = TextEditingController();
class _ShowState extends State<Show> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiMessageController.text = widget.messages;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show single index'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(child:
          Column(
            children: [
              TextFormField(
                initialValue: widget.name,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
                label: Text('Name'),
              ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                initialValue: widget.usertype,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('User Type'),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _apiMessageController,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Messages'),
                ),
              ),
              ElevatedButton(onPressed: (){
                update(_apiMessageController.text.trim().toString(), widget.id);
              }, child: Text('Send'))
            ],
          )
          ),
        ),

      ),
    );
  }

  Future<Response> update(String messages, int id) {
    return put(
      Uri.parse('http://192.168.172.13:8000/api/posts/${id.toString()}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'messages': messages,
      }),
    );
  }
}
