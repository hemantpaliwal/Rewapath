import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',  // Replace
    anonKey: 'YOUR_ANON_KEY',  // Replace
  );
  runApp(const RewaPathApp());
}

class RewaPathApp extends StatelessWidget {
  const RewaPathApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RewaPath',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthGate(),
    );
  }
}
