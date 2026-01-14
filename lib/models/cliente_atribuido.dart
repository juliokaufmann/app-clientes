class ClienteAtribuido {
  final String atribuicaoId;
  final String razaoSocial;
  final String servicoNome;
  final String unidadeNome;
  final String clienteId;
  final String servicoId;
  final String unidadeId;

  ClienteAtribuido({
    required this.atribuicaoId,
    required this.razaoSocial,
    required this.servicoNome,
    required this.unidadeNome,
    required this.clienteId,
    required this.servicoId,
    required this.unidadeId,
  });

  factory ClienteAtribuido.fromJson(Map<String, dynamic> json) {
    return ClienteAtribuido(
      atribuicaoId: json['atribuição_id']?.toString() ?? '',
      razaoSocial: json['razao_social'] ?? '',
      servicoNome: json['servico_nome'] ?? '',
      unidadeNome: json['unidade_nome'] ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      servicoId: json['servico_id']?.toString() ?? '',
      unidadeId: json['unidade_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'atribuição_id': atribuicaoId,
      'razao_social': razaoSocial,
      'servico_nome': servicoNome,
      'unidade_nome': unidadeNome,
      'cliente_id': clienteId,
      'servico_id': servicoId,
      'unidade_id': unidadeId,
    };
  }
}
