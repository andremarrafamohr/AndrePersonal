// File: lib/main.dart

import 'package:flutter/material.dart';
import 'src/screens/ads/view/AdsScreen.dart';
import 'src/screens/ads/view/AddAdScreen.dart';
import 'src/screens/analysis/view/SalesAnalysisScreen.dart';
import 'src/screens/customers/view/CustomersScreen.dart';
import 'src/screens/customers/view/AddCustomerScreen.dart';

void main() => runApp(const HelloFarmerApp());

class HelloFarmerApp extends StatelessWidget {
  const HelloFarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelloFarmer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.green),
          unselectedIconTheme: IconThemeData(color: Colors.black54),
        ),
      ),
      home: const RootNavigation(),
      routes: {
        '/addAd': (context) => const AddAdScreen(initialData: {},),
        '/addCustomer': (context) => const AddCustomerScreen(),
      },
    );
  }
}

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedIndex = 3; // default to 'Gestão'

  final List<Widget> _mainTabs = [
    Center(child: Text('Home')),
    Center(child: Text('Minhas Vendas')),
    Center(child: Text('Minha Banca')),
    const ManagementSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainTabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Minhas Vendas'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Minha Banca'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Gestão'),
        ],
      ),
    );
  }
}

class ManagementSection extends StatefulWidget {
  const ManagementSection({super.key});

  @override
  State<ManagementSection> createState() => _ManagementSectionState();
}

class _ManagementSectionState extends State<ManagementSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Geral'),         // Nova tab à esquerda
    Tab(text: 'Anúncios'),
    Tab(text: 'Análise'),
    Tab(text: 'Clientes'),
    Tab(text: 'Encomendas'),    // Nova tab à direita
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/logo.png', width: 40, height: 40),
              const Text('Gestão', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Pontos: 100'),
                  CircleAvatar(radius: 16, backgroundImage: AssetImage('assets/user.png')),
                ],
              )
            ],
          ),
        ),
        TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.green,
          tabs: _tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: Text('Geral')),        // Placeholder
              AdsScreen(),
              SalesAnalysisScreen(),
              CustomersScreen(),
              Center(child: Text('Encomendas')),   // Placeholder
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

