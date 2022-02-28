import 'dart:convert';
import 'package:flutter_image_search/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 主界面
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
        return GestureDetector(
          child: Image.network(url),
          onLongPress: () {
            Utils.download(url);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ImageDetailPage(url: url)),
            );
          },
        );
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
          Row(
            children: [
              Expanded(child: TextField(onSubmitted: (query) {
                searchText = query;
                getImgList(searchText);
              }))
            ],
          ),
          Container(
            child: imgList(),
          )
        ],
      ),
    );
  }
}

// 点击图片放大界面，支持长按下载
class ImageDetailPage extends StatelessWidget {
  final String url;
  const ImageDetailPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
      onLongPress: () {
        Utils.download(url);
      },
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
