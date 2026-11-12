import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

void main() => runApp(const MobilisApp());

class MobilisApp extends StatelessWidget {
  const MobilisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobilis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      home: const Scaffold(
        body: Center(child: Text('Mobilis')),
      ),
    );
  }
}
