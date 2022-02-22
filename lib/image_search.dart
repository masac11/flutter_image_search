import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//todo 分页，懒加载，点击放大
class ImageSearch extends StatefulWidget {
  const ImageSearch({Key? key}) : super(key: key);

  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  final String apiAddr = "http://xxx";
  List<String> imgData = <String>[];
  @override
  initState() {
    super.initState();
  }

  getImgList(String searchText) async {
    String url = apiAddr + "/kw=" + searchText;
    var res = await http.get(url);
    var resJson = jsonDecode(res.body);
    setState(() {
      imgData.addAll(resJson['data']);
    });
  }

  Widget imgList() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          String url = imgData[index];
          return Image.network(url);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(child: TextField(onSubmitted: (query) {
                  getImgList(query);
                }))
              ],
            ),
          ),
          Container(
            child: imgList(),
          )
        ],
      ),
    );
  }
}
