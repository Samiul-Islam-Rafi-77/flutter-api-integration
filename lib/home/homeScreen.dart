import 'dart:convert';

import 'package:api_intrigration/home/model/homepageModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  // fatchData() async {
  //   await http.get(Uri());
  // }
  List<Homepage> getPostlist = [];

  Future<List<Homepage>> getPostAPI() async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      print("Succesfull");

      for (Map<String, dynamic> i in data) {
        getPostlist.add(Homepage.fromJson(i));
      }

      return getPostAPI();
    } else {
      print("Not Succesfull");
      return getPostAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Daffodil International University",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostAPI(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(child: Text("Loading"));
                } else {
                  return Text("Has Data");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
