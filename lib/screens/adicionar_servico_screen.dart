import 'package:flutter/material.dart';
import '../models/servico.dart';
import '../models/unidade.dart';
import '../services/servico_service.dart';
import '../services/unidade_service.dart';
import '../services/cliente_atribuido_service.dart';
import '../widgets/cindapa_logo.dart';
import '../theme/app_theme.dart';

class AdicionarServicoScreen extends StatefulWidget {
  final String clienteId;
  final String? atribuicaoId;
  final String? servicoIdInicial;
  final String? unidadeIdInicial;

  const AdicionarServicoScreen({
    super.key,
    required this.clienteId,
    this.atribuicaoId,
    this.servicoIdInicial,
    this.unidadeIdInicial,
  });

  @override
  State<AdicionarServicoScreen> createState() => _AdicionarServicoScreenState();
}

class _AdicionarServicoScreenState extends State<AdicionarServicoScreen> {
  final ServicoService _servicoService = ServicoService();
  final UnidadeService _unidadeService = UnidadeService();
  final ClienteAtribuidoService _atribuidoService = ClienteAtribuidoService();

  List<Servico> _servicos = [];
  List<Unidade> _unidades = [];
  bool _isLoading = true;
  String? _errorMessage;

  String? _servicoSelecionado;
  String? _unidadeSelecionada;

  @override
  void initState() {
    super.initState();
    _servicoSelecionado = widget.servicoIdInicial;
    _unidadeSelecionada = widget.unidadeIdInicial;
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final servicos = await _servicoService.buscarServicos();
      final unidades = await _unidadeService.buscarUnidades();

      setState(() {
        _servicos = servicos;
        _unidades = unidades;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _salvar() async {
    if (_servicoSelecionado == null || _unidadeSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um serviço e uma unidade'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      if (widget.atribuicaoId != null) {
        // Atualizar atribuição existente
        await _atribuidoService.atualizarAtribuicao(
          atribuicaoId: widget.atribuicaoId!,
          servicoId: _servicoSelecionado!,
          unidadeId: _unidadeSelecionada!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço atualizado com sucesso')),
          );
        }
      } else {
        // Adicionar nova atribuição
        await _atribuidoService.adicionarAtribuicao(
          clienteId: widget.clienteId,
          servicoId: _servicoSelecionado!,
          unidadeId: _unidadeSelecionada!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço adicionado com sucesso')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
            Text(widget.atribuicaoId != null ? 'Editar Serviço' : 'Adicionar Serviço'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentBlue,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: AppTheme.accentBlue),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar dados',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _carregarDados,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dropdown de Serviços
                      DropdownButtonFormField<String>(
                        value: _servicoSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Serviço',
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        items: _servicos.map((servico) {
                          return DropdownMenuItem<String>(
                            value: servico.id,
                            child: Text(servico.descricao),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _servicoSelecionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dropdown de Unidades
                      DropdownButtonFormField<String>(
                        value: _unidadeSelecionada,
                        decoration: const InputDecoration(
                          labelText: 'Unidade',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        items: _unidades.map((unidade) {
                          return DropdownMenuItem<String>(
                            value: unidade.id,
                            child: Text(unidade.descricao),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _unidadeSelecionada = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Botão Salvar
                      ElevatedButton.icon(
                        onPressed: _salvar,
                        icon: const Icon(Icons.save),
                        label: Text(widget.atribuicaoId != null ? 'Atualizar' : 'Adicionar'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
