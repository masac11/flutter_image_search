import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//todo 点击放大
class ImageSearch extends StatefulWidget {
  const ImageSearch({Key? key}) : super(key: key);

  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  final String apiAddr = "http://xxx";
  final int limit = 24;
  int start = 0;
  int more = 0;
  String searchText = "";
  List<String> imgData = <String>[];

  @override
  initState() {
    super.initState();
  }

  getImgList(String searchText) async {
    String url1 = apiAddr + "/kw=" + searchText;
    var httpsUri = Uri(
      scheme: 'https',
      host: 'host',
      path: '/path?kw' +
          searchText +
          "&start=" +
          start.toString() +
          "&limit=" +
          limit.toString(),
    );
    var res = await http.get(httpsUri);
    var resJson = jsonDecode(res.body);
    more = int.parse(resJson['more'].toString()); //是否还有下一页
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
        if (index == imgData.length - 1 && more == 1) {
          start += limit;
          getImgList(searchText);
        }
        return Image.network(url);
      },
      itemCount: imgData.length,
    );
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
                  searchText = query;
                  getImgList(searchText);
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
