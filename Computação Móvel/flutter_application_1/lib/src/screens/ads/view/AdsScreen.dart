import 'package:flutter/material.dart';
import '/src/screens/ads/models/AdModels.dart';
import 'AddAdScreen.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final List<Ad> _ads = [
    Ad(
      title: 'Curgete',
      description: 'Curgete dia 18 a 21 de maio está a 10% desconto! Aproveita já!',
    ),
  ];

  void _addAd(Ad ad) {
    setState(() {
      _ads.add(ad);
    });
  }

  void _navigateToAddAd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAdScreen(initialData: {}),
      ),
    );
    if (result != null && result is Map<String, String>) {
      _addAd(Ad.fromMap(result));
    }
  }

  void _navigateToEditAd(int index) async {
    final ad = _ads[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAdScreen(initialData: ad.toMap()),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        _ads[index] = Ad.fromMap(result);
      });
    }
  }

  void _openRemoveDialog() async {
    final List<Ad> selectedToRemove = [];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecionar Anúncios para Remover'),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return ListView(
                  shrinkWrap: true,
                  children: _ads.map((ad) {
                    final isSelected = selectedToRemove.contains(ad);
                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(ad.title),
                      subtitle: Text(ad.description),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedToRemove.add(ad);
                          } else {
                            selectedToRemove.remove(ad);
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
                  _ads.removeWhere((ad) => selectedToRemove.contains(ad));
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
                  'Anúncios',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      heroTag: 'deleteAds',
                      onPressed: _openRemoveDialog,
                      tooltip: 'Remover anúncios',
                      child: const Icon(Icons.delete),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      heroTag: 'addAds',
                      onPressed: _navigateToAddAd,
                      tooltip: 'Adicionar anúncio',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _ads.isEmpty
                  ? const Center(child: Text('Nenhum anúncio disponível.'))
                  : ListView.builder(
                      itemCount: _ads.length,
                      itemBuilder: (context, index) {
                        final ad = _ads[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(ad.title),
                            subtitle: Text(ad.description),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _navigateToEditAd(index),
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
}
