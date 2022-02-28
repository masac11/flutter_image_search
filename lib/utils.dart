import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:oktoast/oktoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class Utils {
  static Future<void> requestPermisson() async {
    await [Permission.storage].request();
  }

  static void download(String url) async {
    requestPermisson();
    if (await Permission.storage.request().isGranted) {
      showToast('保存中...');
      bool success;
      if (url.endsWith("gif")) {
        success = await _saveGif(url);
      } else {
        success = await _saveImage(url);
      }
      if (success) {
        showToast("保存成功");
      } else {
        showToast("保存失败");
      }
    } else {
      showToast("保存失败,您没有授权喔");
    }
  }

  static String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  static Future<bool> _saveImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    return result["isSuccess"];
  }

  static Future<bool> _saveGif(String url) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/" + generateRandomString(16) + ".gif";
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    return result["isSuccess"];
  }
}
