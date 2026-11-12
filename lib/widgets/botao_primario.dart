import 'package:flutter/material.dart';

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  final IconData? icone;

  const BotaoPrimario({super.key, required this.texto, required this.onPressed, this.icone});

  @override
  Widget build(BuildContext context) {
    if (icone == null) {
      return ElevatedButton(onPressed: onPressed, child: Text(texto));
    }
    return ElevatedButton.icon(onPressed: onPressed, icon: Icon(icone), label: Text(texto));
  }
}
