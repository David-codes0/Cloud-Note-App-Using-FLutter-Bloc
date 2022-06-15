import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utility/dialogs/delete_dialog.dart';

typedef DeleteNoteCallBack = void Function (DatabaseNote note);

class NoteListView extends StatelessWidget {

  final List<DatabaseNote> notes;
  final DeleteNoteCallBack onDeleteNote;
  const NoteListView({Key? key,
    required this.notes,
    required this.onDeleteNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
          itemBuilder: (context,index) {
            final note = notes[index];
            return ListTile(
              title: Text(
                note.text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete){
                      onDeleteNote(note);
                    }
                },
                icon: const Icon(Icons.delete)),
              );
            },
        );
  }
}