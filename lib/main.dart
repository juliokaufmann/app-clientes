import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/clientes_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // IMPORTANTE: Substitua estas credenciais pelas suas do Supabase
  await Supabase.initialize(
    url: 'https://supabase.apps.cindapa.cloud/',
    anonKey:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTc2MzM0ODQ2MCwiZXhwIjo0OTE5MDIyMDYwLCJyb2xlIjoiYW5vbiJ9.i5Jp8Vb9w3s5g33hPCOfC1WJsshNxF3p6h-SrmDd0qM',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cindapa - Clientes',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const ClientesScreen(),
    );
  }
}
