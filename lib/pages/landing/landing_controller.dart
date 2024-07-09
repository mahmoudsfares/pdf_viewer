import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_sample/data/resource_states.dart';

class LandingController {

  final Rx<StateResource<String>> _loadFileState = StateResource<String>.init().obs;
  StateResource<String> get loadFileState => _loadFileState.value;

  Future<void> createFileOfPdfUrl(String url) async {
    _loadFileState.value = StateResource.loading();
    try {
      Uint8List fileBytes = await _downloadFile(url);
      Directory directory = await getApplicationDocumentsDirectory();
      String filename = url.substring(url.lastIndexOf("/") + 1);
      File file = File("${directory.path}/$filename");
      // when flush is set to true: the data is written directly to the file, won't risk losing data.
      // if set to false, the data may be buffered in memory for a short period, this will slightly improve
      // performance but but comes with a risk of data loss if the application crashes before the buffer is flushed.
      await file.writeAsBytes(fileBytes, flush: true);
      _loadFileState.value = StateResource.success(file.path);
    } catch (e) {
      _loadFileState.value = StateResource.error(e.toString());
    }
  }

  Future<Uint8List> _downloadFile(String url) async {
    HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }
}
