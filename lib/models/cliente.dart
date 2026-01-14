class Cliente {
  final String id;
  final String? cpf;
  final String? cnpj;
  final String? classificacao;
  final String? endereco;
  final String? razaoSocial;
  final String? nomeFantasia;

  Cliente({
    required this.id,
    this.cpf,
    this.cnpj,
    this.classificacao,
    this.endereco,
    this.razaoSocial,
    this.nomeFantasia,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id']?.toString() ?? '',
      cpf: json['cpf'],
      cnpj: json['cnpj'],
      classificacao: json['classificacao'],
      endereco: json['endereco'],
      razaoSocial: json['razao_social'],
      nomeFantasia: json['nome_fantasia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpf': cpf,
      'cnpj': cnpj,
      'classificacao': classificacao,
      'endereco': endereco,
      'razao_social': razaoSocial,
      'nome_fantasia': nomeFantasia,
    };
  }

  // Retorna o nome de exibição (nome fantasia ou razão social)
  String get nomeExibicao {
    return nomeFantasia ?? razaoSocial ?? 'Sem nome';
  }
}
