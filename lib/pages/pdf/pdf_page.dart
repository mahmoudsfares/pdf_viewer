import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';
import 'package:pdf_sample/pages/pdf/pdf_controller.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({super.key, this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> pdfController = Completer<PDFViewController>();

  final PDFController controller = PDFController();

  final int catalogueId = 1;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    controller.getBookmark(catalogueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document")),
      body: Obx(
        () {
          int bookmark = controller.bookmarkPage.value;
          if (bookmark == -2) {
            return const CircularProgressIndicator();
          }
          return Stack(
            children: <Widget>[
              PDFView(
                filePath: widget.path,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: true,
                pageSnap: true,
                defaultPage: bookmark < 0 ? 0 : bookmark,
                fitPolicy: FitPolicy.BOTH,
                // if set to true the link is handled in flutter
                preventLinkNavigation: false,
                onRender: (pageCount) {
                  setState(() {
                    isReady = true;
                  });
                },
                onError: (error) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                  print(error.toString());
                },
                onPageError: (page, error) {
                  setState(() {
                    errorMessage = '$page: ${error.toString()}';
                  });
                  print('$page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  pdfController.complete(pdfViewController);
                },
                onPageChanged: (int? page, int? total) {
                  controller.currentPage.value = page ?? 0;
                },
              ),
              errorMessage.isEmpty
                  ? !isReady
                      ? const Center(child: CircularProgressIndicator())
                      : Container()
                  : Center(
                      child: Text(errorMessage),
                    )
            ],
          );
        },
      ),
      floatingActionButton: Obx(() {
        bool isBookmarked = controller.currentPage.value == controller.bookmarkPage.value;
        return FutureBuilder(
          future: pdfController.future,
          builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
            if (snapshot.hasData) {
              return FloatingActionButton(
                onPressed: () async {
                  Bookmark bookmark = Bookmark(catalogueId: catalogueId, pageNumber: controller.currentPage.value);
                  isBookmarked ? await controller.removeBookmark(bookmark) : await controller.addBookmark(bookmark);
                },
                backgroundColor: Colors.white,
                child: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.black),
              );
            }
            return const SizedBox();
          },
        );
      }),
    );
  }
}
