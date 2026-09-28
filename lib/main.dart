import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/account_service.dart';
import 'data/in_memory_accounts.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FamilyHabitsApp(accounts: await _accounts(), settings: AppSettings()));
}

/// Firebase when the project is connected, otherwise in-memory accounts.
Future<AccountService> _accounts() async {
  final FirebaseOptions options;
  try {
    options = DefaultFirebaseOptions.currentPlatform;
  } on UnsupportedError {
    return InMemoryAccountService();
  }
  await Firebase.initializeApp(options: options);
  return FirebaseAccountService(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
}
