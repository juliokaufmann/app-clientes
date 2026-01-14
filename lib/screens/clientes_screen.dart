import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/cliente.dart';
import '../models/filtros_cliente.dart';
import '../services/cliente_service.dart';
import '../utils/formatters.dart';
import '../widgets/cindapa_logo.dart';
import '../theme/app_theme.dart';
import '../config/app_mode.dart';
import '../config/app_router.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClienteService _clienteService = ClienteService();
  List<Cliente> _clientes = [];
  bool _isLoading = true;
  String? _errorMessage;
  FiltrosCliente _filtrosAtivos = FiltrosCliente();
  late final AppMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = AppRouter.currentMode;
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientes = await _clienteService.buscarClientes(
        filtros: _filtrosAtivos.temFiltros ? _filtrosAtivos : null,
      );
      setState(() {
        _clientes = clientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _abrirFiltros() async {
    final filtros = await context.push<FiltrosCliente>(
      '${_mode.pathPrefix}/filtros',
      extra: _filtrosAtivos,
    );

    if (filtros != null) {
      setState(() {
        _filtrosAtivos = filtros;
      });
      _carregarClientes();
    }
  }

  void _limparFiltros() {
    setState(() {
      _filtrosAtivos = FiltrosCliente();
    });
    _carregarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CindapaLogo(height: 32),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Clientes'),
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
          if (_filtrosAtivos.temFiltros)
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: _abrirFiltros,
              tooltip: 'Filtros Ativos',
              color: AppTheme.accentBlue,
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _abrirFiltros,
            tooltip: 'Filtros',
          ),
          if (_filtrosAtivos.temFiltros)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _limparFiltros,
              tooltip: 'Limpar Filtros',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarClientes,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentBlue,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.accentBlue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar clientes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _carregarClientes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : _clientes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppTheme.textGray,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum cliente encontrado',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione clientes na sua base do Supabase',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _carregarClientes,
                      child: ListView.builder(
                        itemCount: _clientes.length,
                        itemBuilder: (context, index) {
                          final cliente = _clientes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.accentBlue, AppTheme.lightBlue],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    cliente.razaoSocial != null &&
                                            cliente.razaoSocial!.isNotEmpty
                                        ? cliente.razaoSocial![0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: AppTheme.primaryBlack,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                cliente.razaoSocial ?? 'Sem razão social',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.textWhite,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Classificação
                                  if (cliente.classificacao != null &&
                                      cliente.classificacao!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.category,
                                            size: 16,
                                            color: AppTheme.accentBlue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            cliente.classificacao!,
                                            style: const TextStyle(
                                              color: AppTheme.textGray,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // CNPJ se for PESSOA JURÍDICA
                                  if (cliente.classificacao != null &&
                                      cliente.classificacao!
                                          .toUpperCase()
                                          .contains('PESSOA JURÍDICA') &&
                                      cliente.cnpj != null &&
                                      cliente.cnpj!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.business_center,
                                            size: 16,
                                            color: AppTheme.accentBlue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'CNPJ: ${Formatters.formatarCNPJ(cliente.cnpj!)}',
                                            style: const TextStyle(
                                              color: AppTheme.textGray,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // CPF se não for PESSOA JURÍDICA
                                  if (cliente.classificacao != null &&
                                      !cliente.classificacao!
                                          .toUpperCase()
                                          .contains('PESSOA JURÍDICA') &&
                                      cliente.cpf != null &&
                                      cliente.cpf!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.badge,
                                            size: 16,
                                            color: AppTheme.accentBlue,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'CPF: ${Formatters.formatarCPF(cliente.cpf!)}',
                                            style: const TextStyle(
                                              color: AppTheme.textGray,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: AppTheme.accentBlue,
                              ),
                              onTap: () {
                                context.push(
                                  '${_mode.pathPrefix}/cliente/${cliente.id}',
                                  extra: cliente.toJson(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
