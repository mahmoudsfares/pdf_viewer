import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:pdf_sample/data/resource_states.dart';
import 'package:pdf_sample/pages/landing/landing_controller.dart';
import 'package:pdf_sample/pages/pdf/pdf_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  static const String url = "https://pdfkit.org/docs/guide.pdf";
  final LandingController controller = LandingController();

  @override
  void initState() {
    super.initState();
    NoScreenshot.instance.screenshotOff();
    controller.createFileOfPdfUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF reader')),
      body: Center(
        child: Obx(() {
          StateResource loadFileState = controller.loadFileState;
          if (loadFileState.isInit() || loadFileState.isLoading()) {
            return const CircularProgressIndicator();
          }
          if (loadFileState.isError()) {
            String error = loadFileState.error!;
            return Text(error);
          }
          String pdfPath = loadFileState.data as String;
          return ElevatedButton(
            child: const Text('Open file'),
            onPressed: () {
              if (pdfPath.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PDFScreen(path: pdfPath)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Error occurred: file path is empty'),
                    action: SnackBarAction(label: 'Dismiss', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                  ),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
