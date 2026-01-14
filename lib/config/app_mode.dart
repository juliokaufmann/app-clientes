/// Enum que representa os modos de operação do app
enum AppMode {
  edit,
  view;

  /// Retorna o modo baseado na URL
  static AppMode fromPath(String path) {
    if (path.startsWith('/edit')) {
      return AppMode.edit;
    } else if (path.startsWith('/view')) {
      return AppMode.view;
    }
    // Default é edit para manter compatibilidade
    return AppMode.edit;
  }

  /// Retorna o prefixo da URL para o modo
  String get pathPrefix {
    switch (this) {
      case AppMode.edit:
        return '/edit';
      case AppMode.view:
        return '/view';
    }
  }

  /// Retorna se o modo permite edição
  bool get canEdit => this == AppMode.edit;

  /// Retorna o nome do modo para exibição
  String get displayName {
    switch (this) {
      case AppMode.edit:
        return 'Edição';
      case AppMode.view:
        return 'Visualização';
    }
  }
}
