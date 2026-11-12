class Pedido {
  final int equipamentoId;
  final String tipo;
  final String instituicao;
  final String modalidade;
  final DateTime data;
  final String status;

  const Pedido({
    required this.equipamentoId,
    required this.tipo,
    required this.instituicao,
    required this.modalidade,
    required this.data,
    this.status = 'Reservado',
  });

  String get dataFormatada =>
      '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        equipamentoId: json['equipamentoId'] as int,
        tipo: (json['tipo'] ?? '') as String,
        instituicao: (json['instituicao'] ?? '') as String,
        modalidade: json['modalidade'] as String,
        data: DateTime.parse(json['data'] as String),
        status: (json['status'] ?? 'Reservado') as String,
      );

  Map<String, dynamic> toJson() => {
        'equipamentoId': equipamentoId,
        'tipo': tipo,
        'instituicao': instituicao,
        'modalidade': modalidade,
        'data': data.toIso8601String(),
        'status': status,
      };
}
