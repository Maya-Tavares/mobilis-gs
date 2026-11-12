import 'package:flutter/material.dart';

import '../services/preferencias_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prefs = PreferenciasService();

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final resultados = await Future.wait([
      _prefs.onboardingVisto(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);
    if (!mounted) return;
    final visto = resultados.first as bool;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => visto ? const HomeScreen() : const OnboardingScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.primaria,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 140, height: 140),
            const SizedBox(height: AppEspacos.md),
            const Text('Mobilis',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: AppEspacos.xs),
            const Text('Equipamentos de apoio à saúde, com solidariedade',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppEspacos.xl),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
