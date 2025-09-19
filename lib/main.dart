import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'app_module.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  // IMPORTANTE: Substitua pelas suas credenciais do Supabase
  await SupabaseService.initialize(
    url: 'https://oixchzeanvnkiuqdrhlo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9peGNoemVhbnZua2l1cWRyaGxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNjcwNzQsImV4cCI6MjA3Mjc0MzA3NH0.FBJXtGf94w23YXTVjjXkINsceRt6BW5p5S0m_5o5cik',
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: const ConexaoOliviaApp(),
    ),
  );
}

class ConexaoOliviaApp extends StatelessWidget {
  const ConexaoOliviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Conexão Olivia',
      theme: AppTheme.lightTheme,
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
      // Configurações de localização para pt-BR
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português brasileiro
        Locale('en', 'US'), // Inglês (fallback)
      ],
    );
  }
}