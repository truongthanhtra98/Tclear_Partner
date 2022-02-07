import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final Firestore store = Firestore.instance;
final FirebaseDatabase database = FirebaseDatabase.instance;
final FirebaseStorage storage = FirebaseStorage.instance;