import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/filtros_cliente.dart';
import '../widgets/cindapa_logo.dart';

class FiltrosScreen extends StatefulWidget {
  final FiltrosCliente filtrosIniciais;

  const FiltrosScreen({
    super.key,
    required this.filtrosIniciais,
  });

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  late TextEditingController _razaoSocialController;
  late TextEditingController _classificacaoController;
  late TextEditingController _cpfController;
  late TextEditingController _cnpjController;

  @override
  void initState() {
    super.initState();
    _razaoSocialController = TextEditingController(
      text: widget.filtrosIniciais.razaoSocial ?? '',
    );
    _classificacaoController = TextEditingController(
      text: widget.filtrosIniciais.classificacao ?? '',
    );
    _cpfController = TextEditingController(
      text: widget.filtrosIniciais.cpf ?? '',
    );
    _cnpjController = TextEditingController(
      text: widget.filtrosIniciais.cnpj ?? '',
    );
  }

  @override
  void dispose() {
    _razaoSocialController.dispose();
    _classificacaoController.dispose();
    _cpfController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  FiltrosCliente _obterFiltros() {
    return FiltrosCliente(
      razaoSocial: _razaoSocialController.text.trim().isEmpty
          ? null
          : _razaoSocialController.text.trim(),
      classificacao: _classificacaoController.text.trim().isEmpty
          ? null
          : _classificacaoController.text.trim(),
      cpf: _cpfController.text.trim().isEmpty
          ? null
          : _cpfController.text.trim(),
      cnpj: _cnpjController.text.trim().isEmpty
          ? null
          : _cnpjController.text.trim(),
    );
  }

  void _aplicarFiltros() {
    Navigator.pop(context, _obterFiltros());
  }

  void _limparFiltros() {
    setState(() {
      _razaoSocialController.clear();
      _classificacaoController.clear();
      _cpfController.clear();
      _cnpjController.clear();
    });
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
            const Text('Filtros'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _limparFiltros,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Razão Social
            TextField(
              controller: _razaoSocialController,
              decoration: const InputDecoration(
                labelText: 'Razão Social',
                hintText: 'Digite a razão social',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Classificação
            TextField(
              controller: _classificacaoController,
              decoration: const InputDecoration(
                labelText: 'Classificação',
                hintText: 'Ex: PESSOA JURÍDICA, PESSOA FÍSICA',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // CPF
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                hintText: '000.000.000-00',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                _CPFInputFormatter(),
              ],
            ),
            const SizedBox(height: 16),

            // CNPJ
            TextField(
              controller: _cnpjController,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                hintText: '00.000.000/0000-00',
                prefixIcon: Icon(Icons.business_center),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(14),
                _CNPJInputFormatter(),
              ],
            ),
            const SizedBox(height: 32),

            // Botão Aplicar
            ElevatedButton.icon(
              onPressed: _aplicarFiltros,
              icon: const Icon(Icons.search),
              label: const Text('Aplicar Filtros'),
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

// Formatter para CPF
class _CPFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('-');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Formatter para CNPJ
class _CNPJInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1) buffer.write('.');
      if (i == 4) buffer.write('.');
      if (i == 7) buffer.write('/');
      if (i == 11) buffer.write('-');
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
