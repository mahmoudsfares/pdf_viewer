import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_sample/data/entities/note.dart';
import 'package:pdf_sample/data/resource_states.dart';
import 'package:pdf_sample/pages/notes/note_tile.dart';
import 'package:pdf_sample/pages/pdf/pdf_controller.dart';

class NotesBMS extends StatefulWidget {
  final PDFController controller;

  const NotesBMS({required this.controller, super.key});

  @override
  State<NotesBMS> createState() => _NotesBMSState();
}

class _NotesBMSState extends State<NotesBMS> {

  @override
  void initState() {
    super.initState();
    widget.controller.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          StateResource stateResource = widget.controller.notes.value;
          if (stateResource.isLoading()) {
            return const Center(child: CircularProgressIndicator());
          }
          if (stateResource.isError()) {
            return const Center(child: Text('Error fetching notes'));
          }
          if (stateResource.isSuccess()) {
            List<Note> notes = stateResource.data as List<Note>;
            if (notes.isEmpty) {
            } else {
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return NoteTile(note: notes[index], onRemoveNote: (Note note) {
                    widget.controller.removeNote(note);
                    Navigator.pop(context);
                  });
                },
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
