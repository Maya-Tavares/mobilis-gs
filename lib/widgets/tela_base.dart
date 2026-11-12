import 'package:flutter/material.dart';

/// Scaffold + AppBar padrão do app.
class TelaBase extends StatelessWidget {
  final String titulo;
  final Widget corpo;
  final List<Widget>? acoes;
  final Widget? tituloWidget;
  final bool mostrarVoltar;
  final Widget? bottomNavigationBar;

  const TelaBase({
    super.key,
    required this.titulo,
    required this.corpo,
    this.acoes,
    this.tituloWidget,
    this.mostrarVoltar = true,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: tituloWidget ?? Text(titulo),
        actions: acoes,
        automaticallyImplyLeading: mostrarVoltar,
      ),
      body: SafeArea(child: corpo),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
