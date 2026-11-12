class Perfil {
  final String nome;
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;

  const Perfil({
    this.nome = '',
    this.cep = '',
    this.logradouro = '',
    this.bairro = '',
    this.cidade = '',
  });

  factory Perfil.fromJson(Map<String, dynamic> json) => Perfil(
        nome: (json['nome'] ?? '') as String,
        cep: (json['cep'] ?? '') as String,
        logradouro: (json['logradouro'] ?? '') as String,
        bairro: (json['bairro'] ?? '') as String,
        cidade: (json['cidade'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'cep': cep,
        'logradouro': logradouro,
        'bairro': bairro,
        'cidade': cidade,
      };
}
