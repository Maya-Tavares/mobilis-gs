import 'package:flutter/material.dart';

import '../services/preferencias_service.dart';
import '../theme/app_theme.dart';
import '../widgets/botao_primario.dart';
import 'home_screen.dart';

class _Pagina {
  final IconData icone;
  final String titulo;
  final String descricao;
  const _Pagina(this.icone, this.titulo, this.descricao);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _paginas = [
    _Pagina(Icons.location_on, 'Encontre perto de você',
        'Veja equipamentos de apoio à saúde disponíveis em ONGs, igrejas e hospitais da sua região.'),
    _Pagina(Icons.volunteer_activism, 'Peça por empréstimo ou doação',
        'Escolha a modalidade oferecida pela instituição e solicite sem nenhum custo.'),
    _Pagina(Icons.qr_code_2, 'Retire na instituição com QR code',
        'Apresente seu pedido no horário de retirada e leve o equipamento para casa.'),
  ];

  final _controller = PageController();
  final _prefs = PreferenciasService();
  int _pagina = 0;
  bool _naoMostrar = false;

  bool get _ultima => _pagina == _paginas.length - 1;

  void _ir(int destino) => _controller.animateToPage(destino,
      duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

  Future<void> _concluir() async {
    await _prefs.salvarOnboardingVisto(_naoMostrar);
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _paginas.length,
                onPageChanged: (i) => setState(() => _pagina = i),
                itemBuilder: (context, i) {
                  final p = _paginas[i];
                  return Padding(
                    padding: const EdgeInsets.all(AppEspacos.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: AppCores.primaria.withValues(alpha: 0.12),
                          child: Icon(p.icone, size: 84, color: AppCores.primaria),
                        ),
                        const SizedBox(height: AppEspacos.xl),
                        Text(p.titulo,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: AppEspacos.md),
                        Text(p.descricao,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _paginas.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(AppEspacos.xs),
                    width: i == _pagina ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _pagina ? AppCores.primaria : Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            CheckboxListTile(
              value: _naoMostrar,
              onChanged: (v) => setState(() => _naoMostrar = v ?? false),
              title: const Text('Não mostrar novamente'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppEspacos.lg),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppEspacos.lg, 0, AppEspacos.lg, AppEspacos.md),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pagina == 0 ? null : () => _ir(_pagina - 1),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: AppEspacos.md),
                  Expanded(
                    child: BotaoPrimario(
                      texto: _ultima ? 'Começar' : 'Avançar',
                      onPressed: _ultima ? _concluir : () => _ir(_pagina + 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
