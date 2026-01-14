class Servico {
  final String id;
  final String descricao;
  final String? status;
  final String? idGestor;
  final String? verticalId;
  final String? produtoId;
  final DateTime? createdAt;

  Servico({
    required this.id,
    required this.descricao,
    this.status,
    this.idGestor,
    this.verticalId,
    this.produtoId,
    this.createdAt,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id']?.toString() ?? '',
      descricao: json['descricao'] ?? '',
      status: json['status'],
      idGestor: json['id_jestor']?.toString(),
      verticalId: json['vertical_id']?.toString(),
      produtoId: json['produto_id']?.toString(),
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
      'vertical_id': verticalId,
      'produto_id': produtoId,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
