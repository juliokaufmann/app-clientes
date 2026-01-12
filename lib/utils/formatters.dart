class Formatters {
  // Formata CPF: 000.000.000-00
  static String formatarCPF(String cpf) {
    // Remove caracteres não numéricos
    String apenasNumeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (apenasNumeros.length != 11) {
      return cpf; // Retorna original se não tiver 11 dígitos
    }
    
    return '${apenasNumeros.substring(0, 3)}.${apenasNumeros.substring(3, 6)}.${apenasNumeros.substring(6, 9)}-${apenasNumeros.substring(9)}';
  }

  // Formata CNPJ: 00.000.000/0000-00
  static String formatarCNPJ(String cnpj) {
    // Remove caracteres não numéricos
    String apenasNumeros = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (apenasNumeros.length != 14) {
      return cnpj; // Retorna original se não tiver 14 dígitos
    }
    
    return '${apenasNumeros.substring(0, 2)}.${apenasNumeros.substring(2, 5)}.${apenasNumeros.substring(5, 8)}/${apenasNumeros.substring(8, 12)}-${apenasNumeros.substring(12)}';
  }
}
