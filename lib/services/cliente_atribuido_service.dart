import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_atribuido.dart';

class ClienteAtribuidoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ClienteAtribuido>> buscarAtribuicoesPorCliente(
      String clienteId) async {
    try {
      final response = await _supabase
          .from('ff_clientes_atribuidos')
          .select()
          .eq('cliente_id', clienteId)
          .order('servico_nome', ascending: true);

      return (response as List)
          .map((json) => ClienteAtribuido.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar atribuições: $e');
    }
  }

  Future<void> adicionarAtribuicao({
    required String clienteId,
    required String servicoId,
    required String unidadeId,
  }) async {
    try {
      // Usa função RPC para inserir na tabela do schema clientes
      await _supabase.rpc(
        'adicionar_cliente_servico',
        params: {
          'p_cliente_id': clienteId,
          'p_servico_id': servicoId,
          'p_unidade_id': unidadeId,
        },
      );
      return;
    } catch (e) {
      // Log do erro completo para debug
      print('Erro RPC: $e');
      
      // Se a função RPC não existir ou der erro 404, tenta acesso direto
      try {
        await _supabase.from('clientes_servicos').insert({
          'cliente_id': clienteId,
          'servico_id': servicoId,
          'unidade_id': unidadeId,
        });
      } catch (e2) {
        // Se ambos falharem, lança erro detalhado
        throw Exception(
            'Erro ao adicionar atribuição.\n'
            'Erro RPC: $e\n'
            'Erro direto: $e2\n'
            'Verifique se a função "adicionar_cliente_servico" está no schema "public" e tem permissões adequadas.');
      }
    }
  }

  Future<void> atualizarAtribuicao({
    required String atribuicaoId,
    required String servicoId,
    required String unidadeId,
  }) async {
    try {
      // Usa função RPC para atualizar na tabela do schema clientes
      await _supabase.rpc('atualizar_cliente_servico', params: {
        'p_atribuicao_id': atribuicaoId,
        'p_servico_id': servicoId,
        'p_unidade_id': unidadeId,
      });
    } catch (e) {
      // Se a função RPC não existir, tenta acesso direto
      try {
        await _supabase
            .from('clientes_servicos')
            .update({
              'servico_id': servicoId,
              'unidade_id': unidadeId,
            })
            .eq('id', atribuicaoId);
      } catch (e2) {
        throw Exception(
            'Erro ao atualizar atribuição. Certifique-se de que a função RPC "atualizar_cliente_servico" existe no Supabase. Erro: $e2');
      }
    }
  }

  Future<void> removerAtribuicao(String atribuicaoId) async {
    try {
      // Usa função RPC para remover da tabela do schema clientes
      await _supabase.rpc('remover_cliente_servico', params: {
        'p_atribuicao_id': atribuicaoId,
      });
    } catch (e) {
      // Se a função RPC não existir, tenta acesso direto
      try {
        await _supabase
            .from('clientes_servicos')
            .delete()
            .eq('id', atribuicaoId);
      } catch (e2) {
        throw Exception(
            'Erro ao remover atribuição. Certifique-se de que a função RPC "remover_cliente_servico" existe no Supabase. Erro: $e2');
      }
    }
  }
}
