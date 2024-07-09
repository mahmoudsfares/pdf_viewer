import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:pdf_sample/data/entities/bookmark.dart';
import 'package:pdf_sample/data/resource_states.dart';
import 'package:pdf_sample/pages/notes/add_note_dialog.dart';
import 'package:pdf_sample/pages/notes/notes_bms.dart';
import 'package:pdf_sample/pages/pdf/pdf_controller.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({super.key, this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final PDFController controller = PDFController();

  @override
  void initState() {
    super.initState();
    controller.checkForBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int result) {
              if (result == 0) {
                showDialog(context: context, builder: (_) => AddNoteDialog(controller: controller));
              } else if (result == 1) {
                showModalBottomSheet(context: context, builder: (_) => NotesBMS(controller: controller));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(value: 0, child: Text('Add Note')),
              const PopupMenuItem<int>(value: 1, child: Text('Show Notes')),
            ],
          ),
        ],
      ),
      body: Obx(
        () {
          StateResource bookmark = controller.loadBookmarkState;
          if (bookmark.isInit() || bookmark.isLoading()) {
            return const CircularProgressIndicator();
          }
          if (bookmark.isError()) {
            String error = bookmark.error!;
            return Center(child: Text(error));
          }
          int bookmarkPage = bookmark.data as int;
          return Stack(
            children: <Widget>[
              PDFView(
                filePath: widget.path,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                // if set to false, the user must use a more deliberate scrolling motion to navigate between pages
                pageFling: true,
                // if set to true, the PDF will adjust so that a full page is always visible. if set to false, partial pages can be visible.
                pageSnap: true,
                defaultPage: bookmarkPage < 0 ? 0 : bookmarkPage,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                onError: (error) => controller.onFileLoadingError(error.toString()),
                onPageError: (page, error) => controller.onFileLoadingError(error.toString()),
                onPageChanged: (int? page, int? total) => controller.currentPage.value = page ?? 0,
              ),
            ],
          );
        },
      ),
      floatingActionButton: Obx(() {
        // avoid casting exception when bookmark page data is not ready yet (init, loading..)
        StateResource loadFileState = controller.loadBookmarkState;
        if (!loadFileState.isSuccess()) return const SizedBox();
        int bookmark = controller.loadBookmarkState.data as int;
        bool isBookmarked = controller.currentPage.value == bookmark;
        return FloatingActionButton(
          onPressed: () async {
            Bookmark bookmark = Bookmark(fileId: controller.fileId, pageNumber: controller.currentPage.value);
            isBookmarked ? await controller.removeBookmark(bookmark) : await controller.addBookmark(bookmark);
          },
          backgroundColor: Colors.white,
          child: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.black),
        );
      }),
    );
  }
}
