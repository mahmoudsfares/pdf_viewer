import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:pdf_sample/pages/landing/landing_controller.dart';
import 'package:pdf_sample/pages/pdf/pdf_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final LandingController controller = LandingController();
  String pdfPath = "";

  @override
  void initState() {
    super.initState();
    NoScreenshot.instance.screenshotOff();
    controller.createFileOfPdfUrl().then((f) {
      setState(() {
        pdfPath = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: Column(
          children: <Widget>[
            TextButton(
              child: const Text("Open PDF"),
              onPressed: () {
                if (pdfPath.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDFScreen(path: pdfPath)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
