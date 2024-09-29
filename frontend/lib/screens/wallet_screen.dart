import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet de Voyage'),
      ),
      body: const Center(
        child: Text('Page du wallet'),
      ),
    );
  }
}