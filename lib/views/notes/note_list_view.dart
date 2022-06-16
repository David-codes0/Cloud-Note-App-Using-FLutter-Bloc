import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utility/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function (CloudNote note);

class NoteListView extends StatelessWidget {

 // final List<DatabaseNote> notes;
 final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
          itemBuilder: (context,index) {
           // final note = notes[index];
           final note = notes.elementAt(index);
            return ListTile(
              onTap: () {
                onTap(note);
              },
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