
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';

import 'package:flutter/foundation.dart';
@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudNote ({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });
  
  // to create instance of our cloud note
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) 
  : documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  text = snapshot.data()[textFieldName] as String;


}