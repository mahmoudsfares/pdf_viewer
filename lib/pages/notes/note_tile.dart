import 'package:flutter/material.dart';
import 'package:pdf_sample/data/entities/note.dart';

class NoteTile extends StatelessWidget {

  final Note note;
  final Function(Note) onRemoveNote;

  const NoteTile({required this.note, required this.onRemoveNote, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(note.note)),
        IconButton(onPressed: () => onRemoveNote(note), icon: const Icon(Icons.cancel, color: Colors.red))
      ],
    );
  }
}
