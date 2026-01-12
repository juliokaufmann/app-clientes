import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/unidade.dart';

class UnidadeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Unidade>> buscarUnidades() async {
    try {
      final response = await _supabase
          .from('ff_unidades')
          .select()
          .order('descricao', ascending: true);

      return (response as List)
          .map((json) => Unidade.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar unidades: $e');
    }
  }
}
