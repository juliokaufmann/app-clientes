class FiltrosCliente {
  final String? razaoSocial;
  final String? classificacao;
  final String? cpf;
  final String? cnpj;

  FiltrosCliente({
    this.razaoSocial,
    this.classificacao,
    this.cpf,
    this.cnpj,
  });

  bool get temFiltros {
    return razaoSocial != null &&
            razaoSocial!.isNotEmpty ||
        classificacao != null &&
            classificacao!.isNotEmpty ||
        cpf != null &&
            cpf!.isNotEmpty ||
        cnpj != null &&
            cnpj!.isNotEmpty;
  }

  FiltrosCliente copyWith({
    String? razaoSocial,
    String? classificacao,
    String? cpf,
    String? cnpj,
  }) {
    return FiltrosCliente(
      razaoSocial: razaoSocial ?? this.razaoSocial,
      classificacao: classificacao ?? this.classificacao,
      cpf: cpf ?? this.cpf,
      cnpj: cnpj ?? this.cnpj,
    );
  }

  FiltrosCliente limpar() {
    return FiltrosCliente();
  }
}
