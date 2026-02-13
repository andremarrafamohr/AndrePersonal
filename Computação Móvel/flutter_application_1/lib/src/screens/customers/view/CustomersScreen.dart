import 'package:flutter/material.dart';
import '/src/screens/customers/models/CustomerModels.dart'; // atualize o caminho se necessário

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final List<Customer> _customers = [
    Customer(name: 'João Silva', email: 'joao@email.com', dob: '1990-01-01', contact: '912345678'),
    Customer(name: 'Maria Oliveira', email: 'maria@email.com', dob: '1988-03-14', contact: '913456789'),
    Customer(name: 'Carlos Santos', email: 'carlos@email.com', dob: '1985-06-22', contact: '914567890'),
  ];

  void _navigateToAddCustomer() async {
    final result = await Navigator.pushNamed(context, '/addCustomer');
    if (result != null && result is Map<String, String>) {
      setState(() {
        _customers.add(Customer.fromMap(result));
      });
    }
  }

  void _openRemoveDialog() async {
    final List<Customer> selectedToRemove = [];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecionar Clientes para Remover'),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return ListView(
                  shrinkWrap: true,
                  children: _customers.map((customer) {
                    final bool isSelected = selectedToRemove.contains(customer);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(customer.name),
                      subtitle: Text(customer.email),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedToRemove.add(customer);
                          } else {
                            selectedToRemove.remove(customer);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _customers.removeWhere((c) => selectedToRemove.contains(c));
                });
                Navigator.pop(context);
              },
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Clientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      heroTag: 'deleteBtn',
                      onPressed: _openRemoveDialog,
                      tooltip: 'Remover clientes',
                      child: const Icon(Icons.delete),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      heroTag: 'addBtn',
                      onPressed: _navigateToAddCustomer,
                      tooltip: 'Adicionar cliente',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _customers.isEmpty
                  ? const Center(child: Text('Nenhum cliente disponível.'))
                  : ListView.builder(
                      itemCount: _customers.length,
                      itemBuilder: (context, index) {
                        final customer = _customers[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(customer.name),
                            subtitle: Text(customer.email),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
