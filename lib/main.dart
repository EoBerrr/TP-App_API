import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

import 'scr.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FisrtPage(),
      )
  );
}

class FisrtPage extends StatelessWidget {
  var _categoryNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:
    AppBar(
      title: const Text('Trabalho Final TP'),
      centerTitle: true,
    ),
      body: Material(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(30.0)),
              Image.asset('images/tp.png',
                width: 200.0,
                height: 200.0,
              ),
              ListTile(
                title: TextFormField(
                  controller: _categoryNameController,
                  decoration:  const InputDecoration(
                    labelText: 'Search for a category',
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              ListTile(
                subtitle: Material(
                  child: MaterialButton(onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context){
                        return SecondPage(category: _categoryNameController.text,);
                      })
                    )
                  },),
                  child: const Text('Search',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);
  String category;
  SecondPage({this.category});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: const Text('Trabalho Final TP',
          style: TextStyle(color: Colors.deepOrange),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getPics(widget.category),
        builder: (context, snapShot){
          Map? data = snapShot.data;
          if(snapShot.hasError){
            print(snapShot.error);
            return const Text('Falha ao conectar com o servidor',
              style: TextStyle(color: Colors.black),
            );
          }else if(snapShot.hasData){
            return Center(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index),
                Column(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.all(5.0)),
                    Container(
                    child: InkWell(
                      onTap: (){},
                      child: Image.network('${data}['hits'][index]['largeImageURL']),
                    ),
                    )
                  ],
                );
              ),
            );
          }else if(!snapShot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}

Future<Map> _getPics(String category) async {
  String url = 'https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&pretty=true';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}