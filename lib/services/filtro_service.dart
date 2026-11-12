import '../models/equipamento.dart';

/// Regras de busca e filtro da Home (sem dependência de widgets).
class FiltroEquipamentos {
  static const todos = 'Todos';

  static List<String> tipos(List<Equipamento> lista) =>
      [todos, ...{for (final e in lista) e.tipo}];

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[áàâã]'), 'a')
      .replaceAll(RegExp('[éê]'), 'e')
      .replaceAll('í', 'i')
      .replaceAll(RegExp('[óôõ]'), 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c');

  static List<Equipamento> aplicar(
    List<Equipamento> lista, {
    String busca = '',
    String tipo = todos,
    String modalidade = todos,
  }) {
    final termo = _norm(busca.trim());
    return lista.where((e) {
      if (tipo != todos && e.tipo != tipo) return false;
      if (modalidade != todos && !e.modalidades.contains(modalidade)) return false;
      if (termo.isEmpty) return true;
      final texto = _norm('${e.tipo} ${e.descricao} ${e.instituicao.nome} ${e.instituicao.bairro}');
      return texto.contains(termo);
    }).toList();
  }
}
