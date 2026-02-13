// File: lib/src/screens/analysis/view/SalesAnalysisScreen.dart

import 'package:flutter/material.dart';
import '/src/screens/analysis/models/AnalysisModel.dart';


class SalesAnalysisScreen extends StatelessWidget {
  SalesAnalysisScreen({super.key});

  final List<SalesAnalysis> mockData = [
    SalesAnalysis(
      period: DateTime(2024, 5),
      totalSales: 1200.0,
      totalOrders: 310,
    ),
    SalesAnalysis(
      period: DateTime(2024, 4),
      totalSales: 1085.0,
      totalOrders: 290,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Análise de Vendas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo Mensal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: mockData.length,
                itemBuilder: (context, index) {
                  final analysis = mockData[index];
                  return ListTile(
                    leading: const Icon(Icons.bar_chart, color: Colors.blue),
                    title: Text(
                      'Período: ${analysis.period.month}/${analysis.period.year}',
                    ),
                    subtitle: Text(
                      'Total: ${analysis.totalSales.toStringAsFixed(2)}€\nPedidos: ${analysis.totalOrders}',
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