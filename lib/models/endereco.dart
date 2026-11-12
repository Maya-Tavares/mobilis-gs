class Endereco {
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  const Endereco({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) => Endereco(
        logradouro: (json['logradouro'] ?? '') as String,
        bairro: (json['bairro'] ?? '') as String,
        localidade: (json['localidade'] ?? '') as String,
        uf: (json['uf'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'logradouro': logradouro,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
      };
}
