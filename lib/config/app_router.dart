import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_mode.dart';
import '../screens/clientes_screen.dart';
import '../screens/cliente_detalhes_screen.dart';
import '../screens/adicionar_servico_screen.dart';
import '../screens/filtros_screen.dart';
import '../models/cliente.dart';
import '../models/filtros_cliente.dart';

class AppRouter {
  static AppMode _currentMode = AppMode.edit;

  static AppMode get currentMode => _currentMode;

  static void setModeFromPath(String path) {
    _currentMode = AppMode.fromPath(path);
  }

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: '/edit',
      redirect: (context, state) {
        // Atualiza o modo sempre que a rota muda
        setModeFromPath(state.uri.path);
        return null;
      },
      routes: [
        // Rota para modo de edição
        GoRoute(
          path: '/edit',
          builder: (context, state) {
            return const ClientesScreen();
          },
          routes: [
            GoRoute(
              path: 'cliente/:id',
              builder: (context, state) {
                final clienteJson = state.extra as Map<String, dynamic>?;
                if (clienteJson == null) {
                  return const Scaffold(
                    body: Center(child: Text('Cliente não encontrado')),
                  );
                }
                final cliente = Cliente.fromJson(clienteJson);
                return ClienteDetalhesScreen(cliente: cliente);
              },
              routes: [
                GoRoute(
                  path: 'servico',
                  builder: (context, state) {
                    final clienteId = state.pathParameters['id'] ?? '';
                    return AdicionarServicoScreen(clienteId: clienteId);
                  },
                ),
                GoRoute(
                  path: 'servico/:atribuicaoId',
                  builder: (context, state) {
                    final clienteId = state.pathParameters['id'] ?? '';
                    final atribuicaoId = state.pathParameters['atribuicaoId'];
                    final extra = state.extra as Map<String, dynamic>?;
                    return AdicionarServicoScreen(
                      clienteId: clienteId,
                      atribuicaoId: atribuicaoId,
                      servicoIdInicial: extra?['servicoId'] as String?,
                      unidadeIdInicial: extra?['unidadeId'] as String?,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'filtros',
              builder: (context, state) {
                final filtros = state.extra as FiltrosCliente?;
                return FiltrosScreen(
                  filtrosIniciais: filtros ?? FiltrosCliente(),
                );
              },
            ),
          ],
        ),
        // Rota para modo de visualização
        GoRoute(
          path: '/view',
          builder: (context, state) {
            return const ClientesScreen();
          },
          routes: [
            GoRoute(
              path: 'cliente/:id',
              builder: (context, state) {
                final clienteJson = state.extra as Map<String, dynamic>?;
                if (clienteJson == null) {
                  return const Scaffold(
                    body: Center(child: Text('Cliente não encontrado')),
                  );
                }
                final cliente = Cliente.fromJson(clienteJson);
                return ClienteDetalhesScreen(cliente: cliente);
              },
            ),
            GoRoute(
              path: 'filtros',
              builder: (context, state) {
                final filtros = state.extra as FiltrosCliente?;
                return FiltrosScreen(
                  filtrosIniciais: filtros ?? FiltrosCliente(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
