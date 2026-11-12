import 'package:flutter/material.dart';

import '../widgets/tela_base.dart';

/// Placeholder do checkpoint C; a Home real entra no checkpoint D.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TelaBase(
      titulo: 'Mobilis',
      mostrarVoltar: false,
      corpo: Center(child: Text('Home em construção (checkpoint D)')),
    );
  }
}
