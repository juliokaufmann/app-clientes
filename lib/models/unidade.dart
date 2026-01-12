class Unidade {
  final String id;
  final String descricao;
  final String? status;
  final String? idGestor;
  final DateTime? createdAt;

  Unidade({
    required this.id,
    required this.descricao,
    this.status,
    this.idGestor,
    this.createdAt,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      id: json['id']?.toString() ?? '',
      descricao: json['descricao'] ?? '',
      status: json['status'],
      idGestor: json['id_jestor']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'status': status,
      'id_jestor': idGestor,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
