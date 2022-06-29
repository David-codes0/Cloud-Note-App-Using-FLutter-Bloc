

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {

  final notes = FirebaseFirestore.instance.collection('notes'); // to talk with firestore and create same 'notes. on firebase console.


  

  //creating a SINGLETON
  static final FirebaseCloudStorage _shared = 
  FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance(); // private constructor
  factory FirebaseCloudStorage() => _shared; // factory constructor that talks with the static


  Future<void> deleteNote ({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e){
      throw CouldNotDeleteNoteException();
    }
  }

   Future<void> updateNote ({required String documentId,required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
   }

  // TO GRAB A STREAM A DATA, IF YOU WANT TO SUBCRIBE TO ALL THE CHANGES AS IT IS ENVOLVING
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}){
    final allNotes = 
    notes
    .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
    .snapshots().map((event) => event.docs
    .map((doc) => CloudNote.fromSnapshot(doc))
    .where((note) => note.ownerUserId == ownerUserId,
    ));
    return allNotes;
}
  
   Future<CloudNote> createNewNote({required String ownerUserId}) async {
      final document = await notes.add({
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      },
    );
      final fetchedNote = await document.get();
      return CloudNote(
        documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        text: '',
      );
   }
}

