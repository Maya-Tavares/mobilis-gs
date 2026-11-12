class Instituicao {
  final String nome;
  final String tipo;
  final String endereco;
  final String bairro;
  final String cep;
  final double latitude;
  final double longitude;
  final String horarioRetirada;
  final String telefone;

  const Instituicao({
    required this.nome,
    required this.tipo,
    required this.endereco,
    required this.bairro,
    required this.cep,
    required this.latitude,
    required this.longitude,
    required this.horarioRetirada,
    required this.telefone,
  });

  factory Instituicao.fromJson(Map<String, dynamic> json) => Instituicao(
        nome: json['nome'] as String,
        tipo: json['tipo'] as String,
        endereco: json['endereco'] as String,
        bairro: json['bairro'] as String,
        cep: json['cep'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        horarioRetirada: json['horarioRetirada'] as String,
        telefone: json['telefone'] as String,
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'tipo': tipo,
        'endereco': endereco,
        'bairro': bairro,
        'cep': cep,
        'latitude': latitude,
        'longitude': longitude,
        'horarioRetirada': horarioRetirada,
        'telefone': telefone,
      };
}
