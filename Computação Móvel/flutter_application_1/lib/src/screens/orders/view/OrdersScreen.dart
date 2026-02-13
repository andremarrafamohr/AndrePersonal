import 'package:flutter/material.dart';
import '/src/screens/orders/models/OrdersModel.dart'; // Atualiza o caminho se necessário

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Order> _orders = [
    Order(
      customerName: 'João Silva',
      items: ['100kg Trigo', '50 Un. Tomates'],
      status: 'Pendente',
    ),
    Order(
      customerName: 'Maria Oliveira',
      items: ['20L Azeite', '10 Un. Alface', '30kg Batatas'],
      status: 'Pronto para Recolha',
    ),
    Order(
      customerName: 'Carlos Santos',
      items: ['15kg Cenouras'],
      status: 'Cancelado',
    ),
    Order(
      customerName: 'Ana Costa',
      items: ['10 Un. Laranjas', '2kg Maçãs', '4L Leite', '1kg Café'],
      status: 'Pendente',
    ),
  ];

  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Encomendas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${_orders.length} Encomendas:', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final isExpanded = _expandedStates[index] ?? false;

                  return Card(
                    color: Colors.grey[200],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _expandedStates[index] = !isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.person, size: 40),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.customerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  if (isExpanded)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: order.items
                                          .map((item) => Text(item, style: const TextStyle(fontSize: 14)))
                                          .toList(),
                                    )
                                  else
                                    Text(order.items.first, style: const TextStyle(fontSize: 14)),
                                  if (!isExpanded && order.items.length > 1)
                                    Text('... +${order.items.length - 1} itens', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(order.status),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      case 'pronto para recolha':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
