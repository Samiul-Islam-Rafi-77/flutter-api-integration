import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_intrigration/home/model/homepageModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  //Asingcrunas --> Future, async, await

  late Future<List<Homepage>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = fetchPosts();
  }

  Future<List<Homepage>> fetchPosts() async {
    const String fetchPostsUrl = 'https://jsonplaceholder.typicode.com/posts';
    final Uri uri = Uri.parse(fetchPostsUrl);

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData
          .map((item) => Homepage.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load posts');
  }

  Future<void> addProduct() async {
    //setp1 : set url
    const String addNewProductUrl =
        'https://jsonplaceholder.typicode.com/posts';

    //step-2 : prepare data

    Map<String, dynamic> inputData = {
      "Img": "",
      "ProductCode": "",
      "ProductName": "",
      "Qty": "",
      "TotalPrice": "",
      "UnitPrice": "",
    };

    //URI --> uniform Resorce Identifire
    // URL --> URI
    // step-3 parse
    Uri uri = Uri.parse(addNewProductUrl);

    //POST
    //step-4 : sent request
    http.Response response = await http.post(
      uri,
      body: jsonEncode(inputData),
      headers: {'content-type': 'application/json'},
    );

    
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
              future: postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                } else {
                  final posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ListTile(
                        title: Text(post.title ?? ''),
                        subtitle: Text(post.body ?? ''),
                        leading: CircleAvatar(child: Text('${post.id ?? ''}')),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
