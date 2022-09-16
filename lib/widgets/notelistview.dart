import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mynotes/views/notes/note_list_view.dart';

class NoteListTile extends StatelessWidget {
  const NoteListTile({
    Key? key,
    required this.onDeleteNote,
    required this.child,
  }) : super(key: key);

  final BuildContextCallBack onDeleteNote;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      child: SizedBox(
        height: 200,
        child: Card(
          color: noteColorChanger[rng.nextInt(noteColorChanger.length)],
          shadowColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: onDeleteNote,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: child),
        ),
      ),
    );
  }
}

const List<MaterialColor> noteColorChanger = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.grey
];
