import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utility/dialogs/delete_dialog.dart';
import 'package:mynotes/widgets/notelistview.dart';

typedef NoteCallBack = void Function(CloudNote note);

typedef BuildContextCallBack = void Function(BuildContext context);

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
      itemBuilder: (context, index) {
       
        final note = notes.elementAt(index);
        return NoteListTile(
          onDeleteNote: (context) async {
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              onDeleteNote(note);
            }
          },
          child: ListTile(
            minVerticalPadding: 20,
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        );
      },
    );
  }
}
