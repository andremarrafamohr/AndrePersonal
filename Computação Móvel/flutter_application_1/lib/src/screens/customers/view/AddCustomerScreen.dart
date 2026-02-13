// File: lib/src/screens/customers/view/AddCustomerScreen.dart

import 'package:flutter/material.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _submitCustomer() {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String dob = _dobController.text.trim();
    final String contact = _contactController.text.trim();
    final String email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || dob.isEmpty || contact.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': '$firstName $lastName',
      'email': email,
      'dob': dob,
      'contact': contact,
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Cliente'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nome Próprio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apelido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Contacto',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitCustomer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Adicionar'),
                ),
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancelar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
