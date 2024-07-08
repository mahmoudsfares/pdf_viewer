import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_sample/data/resource_states.dart';

class LandingController {

  Rx<StateResource<String>> loadFileState = StateResource<String>.init().obs;

  Future<void> createFileOfPdfUrl() async {
    loadFileState.value = StateResource.loading();
    try {
      String url = "https://pdfkit.org/docs/guide.pdf";
      String filename = url.substring(url.lastIndexOf("/") + 1);
      HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      loadFileState.value = StateResource.success(file.path);
    } catch (e) {
      loadFileState.value = StateResource.error(e.toString());
    }
  }
}
