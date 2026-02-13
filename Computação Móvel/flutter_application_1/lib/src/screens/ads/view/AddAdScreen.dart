// File: lib/src/screens/ads/view/AddAdScreen.dart

import 'package:flutter/material.dart';

class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key, required Map<String, String> initialData});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedProduct = 'Curgetes';

  void _submitAd() {
    Navigator.pop(context, {
      'title': _selectedProduct,
      'description': _descriptionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Anúncio'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_basket, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Produto'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedProduct,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProduct = newValue!;
                });
              },
              items: <String>['Curgetes', 'Tomates', 'Cenouras']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Descrição'),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Breve descrição do anúncio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitAd,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Adicionar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
