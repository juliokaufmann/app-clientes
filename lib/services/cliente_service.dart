import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente.dart';
import '../models/filtros_cliente.dart';

class ClienteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Cliente>> buscarClientes({FiltrosCliente? filtros}) async {
    try {
      var query = _supabase.from('ff_clientes').select();

      // Aplicar filtros
      if (filtros != null) {
        if (filtros.razaoSocial != null && filtros.razaoSocial!.isNotEmpty) {
          query = query.ilike('razao_social', '%${filtros.razaoSocial}%');
        }

        if (filtros.classificacao != null && filtros.classificacao!.isNotEmpty) {
          query = query.eq('classificacao', filtros.classificacao!);
        }

        if (filtros.cpf != null && filtros.cpf!.isNotEmpty) {
          // Remove formatação do CPF para busca
          String cpfLimpo = filtros.cpf!.replaceAll(RegExp(r'[^0-9]'), '');
          if (cpfLimpo.isNotEmpty) {
            query = query.ilike('cpf', '%$cpfLimpo%');
          }
        }

        if (filtros.cnpj != null && filtros.cnpj!.isNotEmpty) {
          // Remove formatação do CNPJ para busca
          String cnpjLimpo = filtros.cnpj!.replaceAll(RegExp(r'[^0-9]'), '');
          if (cnpjLimpo.isNotEmpty) {
            query = query.ilike('cnpj', '%$cnpjLimpo%');
          }
        }
      }

      final response = await query.order('razao_social', ascending: true);

      return (response as List)
          .map((json) => Cliente.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar clientes: $e');
    }
  }

  Future<Cliente?> buscarClientePorId(String id) async {
    try {
      final response = await _supabase
          .from('ff_clientes')
          .select()
          .eq('id', id)
          .single();

      return Cliente.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }
}
