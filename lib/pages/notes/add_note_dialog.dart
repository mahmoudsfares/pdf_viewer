import 'package:flutter/material.dart';
import 'package:pdf_sample/data/entities/note.dart';
import 'package:pdf_sample/pages/pdf/pdf_controller.dart';

class AddNoteDialog extends StatelessWidget {
  final PDFController controller;
  final TextEditingController textEditingController = TextEditingController();

  AddNoteDialog({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(label: Text('Add note')),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Note note = Note(
              id: null,
              catalogueId: controller.catalogueId,
              pageNumber: controller.currentPage.value,
              note: textEditingController.text,
            );
            controller.addNote(note);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
