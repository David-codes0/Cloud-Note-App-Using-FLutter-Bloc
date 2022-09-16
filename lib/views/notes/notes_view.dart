import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/authbloc.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utility/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/note_list_view.dart';
import 'package:mynotes/widgets/app_custom_button.dart';
import 'package:mynotes/widgets/app_styles.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              final text = context.loc.notes_title(noteCount);
              return Text(
                text,
                style: GoogleFonts.nunito(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return const Text('');
            }
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: kAppBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/drawer.jpg'),
                ),
              ),
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 10,
                  // ),
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/Profile-PNG-File.png'),
                    radius: 40,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Welcome',
                    style: GoogleFonts.sanchez(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: kDarkWhiteColor,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: GoogleFonts.sanchez(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkWhiteColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AuthButton(
                buttonName: 'Logout',
                onPressed: () async {
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            color: kPurpleColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              iconSize: 40,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NoteListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const AppProgressIndicator();
              }
            default:
              return const AppProgressIndicator();
          }
        },
      ),
    );
  }
}
