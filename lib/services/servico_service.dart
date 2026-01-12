import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/servico.dart';

class ServicoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Servico>> buscarServicos() async {
    try {
      final response = await _supabase
          .from('ff_servicos')
          .select()
          .order('descricao', ascending: true);

      return (response as List)
          .map((json) => Servico.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar serviços: $e');
    }
  }
}
