import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/cliente.dart';
import '../models/cliente_atribuido.dart';
import '../services/cliente_atribuido_service.dart';
import '../utils/formatters.dart';
import '../widgets/cindapa_logo.dart';
import '../theme/app_theme.dart';
import '../config/app_mode.dart';
import '../config/app_router.dart';

class ClienteDetalhesScreen extends StatefulWidget {
  final Cliente cliente;

  const ClienteDetalhesScreen({
    super.key,
    required this.cliente,
  });

  @override
  State<ClienteDetalhesScreen> createState() => _ClienteDetalhesScreenState();
}

class _ClienteDetalhesScreenState extends State<ClienteDetalhesScreen> {
  final ClienteAtribuidoService _atribuidoService = ClienteAtribuidoService();
  List<ClienteAtribuido> _atribuicoes = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final AppMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = AppRouter.currentMode;
    _carregarAtribuicoes();
  }

  Future<void> _carregarAtribuicoes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final atribuicoes =
          await _atribuidoService.buscarAtribuicoesPorCliente(widget.cliente.id);
      setState(() {
        _atribuicoes = atribuicoes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _adicionarServico() async {
    if (!_mode.canEdit) return;
    
    final resultado = await context.push<bool>(
      '${_mode.pathPrefix}/cliente/${widget.cliente.id}/servico',
    );

    if (resultado == true) {
      _carregarAtribuicoes();
    }
  }

  Future<void> _editarServico(ClienteAtribuido atribuicao) async {
    if (!_mode.canEdit) return;
    
    final resultado = await context.push<bool>(
      '${_mode.pathPrefix}/cliente/${widget.cliente.id}/servico/${atribuicao.atribuicaoId}',
      extra: {
        'servicoId': atribuicao.servicoId,
        'unidadeId': atribuicao.unidadeId,
      },
    );

    if (resultado == true) {
      _carregarAtribuicoes();
    }
  }

  Future<void> _removerServico(ClienteAtribuido atribuicao) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Remoção'),
        content: Text(
          'Deseja remover o serviço "${atribuicao.servicoNome}" da unidade "${atribuicao.unidadeNome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      try {
        await _atribuidoService.removerAtribuicao(atribuicao.atribuicaoId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço removido com sucesso')),
          );
          _carregarAtribuicoes();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao remover serviço: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CindapaLogo(height: 28),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Detalhes do Cliente'),
                Text(
                  'Modo: ${_mode.displayName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarAtribuicoes,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card com dados do cliente
            Card(
              margin: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.mediumGray,
                      AppTheme.darkGray,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cliente.razaoSocial ?? 'Sem razão social',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.cliente.classificacao != null &&
                        widget.cliente.classificacao!.isNotEmpty)
                      _buildInfoRow(
                        Icons.category,
                        'Classificação',
                        widget.cliente.classificacao!,
                      ),
                    if (widget.cliente.cpf != null &&
                        widget.cliente.cpf!.isNotEmpty)
                      _buildInfoRow(
                        Icons.badge,
                        'CPF',
                        Formatters.formatarCPF(widget.cliente.cpf!),
                      ),
                    if (widget.cliente.cnpj != null &&
                        widget.cliente.cnpj!.isNotEmpty)
                      _buildInfoRow(
                        Icons.business_center,
                        'CNPJ',
                        Formatters.formatarCNPJ(widget.cliente.cnpj!),
                      ),
                    if (widget.cliente.endereco != null &&
                        widget.cliente.endereco!.isNotEmpty)
                      _buildInfoRow(
                        Icons.location_on,
                        'Endereço',
                        widget.cliente.endereco!,
                      ),
                  ],
                ),
              ),
            ),

            // Título da seção de serviços
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Serviços Atribuídos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textWhite,
                    ),
                  ),
                  if (_mode.canEdit)
                    ElevatedButton.icon(
                      onPressed: _adicionarServico,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Lista de serviços
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.accentBlue,
                  ),
                ),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          'Erro ao carregar serviços',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _carregarAtribuicoes,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_atribuicoes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                          const Icon(
                            Icons.work_outline,
                            size: 64,
                            color: AppTheme.textGray,
                          ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum serviço atribuído',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text('Adicione serviços para este cliente'),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _atribuicoes.length,
                itemBuilder: (context, index) {
                  final atribuicao = _atribuicoes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.work,
                          color: AppTheme.accentBlue,
                        ),
                      ),
                      title: Text(
                        atribuicao.servicoNome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textWhite,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Unidade: ${atribuicao.unidadeNome}',
                          style: const TextStyle(
                            color: AppTheme.textGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      trailing: _mode.canEdit
                          ? PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'editar',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'remover',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Remover', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'editar') {
                                  _editarServico(atribuicao);
                                } else if (value == 'remover') {
                                  _removerServico(atribuicao);
                                }
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppTheme.accentBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
