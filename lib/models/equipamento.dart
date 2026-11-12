import 'instituicao.dart';

class Equipamento {
  final int id;
  final String tipo;
  final String descricao;
  final String estadoConservacao;
  final List<String> modalidades;
  final String status;
  final String fotoUrl;
  final Instituicao instituicao;
  final int prazoDiasEmprestimo;

  const Equipamento({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.estadoConservacao,
    required this.modalidades,
    required this.status,
    required this.fotoUrl,
    required this.instituicao,
    required this.prazoDiasEmprestimo,
  });

  factory Equipamento.fromJson(Map<String, dynamic> json) => Equipamento(
        id: json['id'] as int,
        tipo: json['tipo'] as String,
        descricao: json['descricao'] as String,
        estadoConservacao: json['estadoConservacao'] as String,
        modalidades: (json['modalidades'] as List).map((e) => e as String).toList(),
        status: json['status'] as String,
        fotoUrl: json['fotoUrl'] as String,
        instituicao: Instituicao.fromJson(json['instituicao'] as Map<String, dynamic>),
        prazoDiasEmprestimo: json['prazoDiasEmprestimo'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'descricao': descricao,
        'estadoConservacao': estadoConservacao,
        'modalidades': modalidades,
        'status': status,
        'fotoUrl': fotoUrl,
        'instituicao': instituicao.toJson(),
        'prazoDiasEmprestimo': prazoDiasEmprestimo,
      };

  bool get disponivel => status == 'Disponível';
}
