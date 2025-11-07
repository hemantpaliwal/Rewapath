import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 80, color: Colors.green),
            const Text('RewaPath', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone (+91...)'), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                setState(() => _loading = true);
                try {
                  await Supabase.instance.client.auth.signInWithOtp(phone: _phoneController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent!')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
                setState(() => _loading = false);
              },
              child: _loading ? const CircularProgressIndicator() : const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
