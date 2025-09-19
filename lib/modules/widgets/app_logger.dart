// Classe utilitária para logs padronizados
class AppLogger {
  static const bool _isDebugMode = true; // Configurar para false em produção

  // Cores ANSI para terminal (opcional)
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  // Métodos principais
  static void info(String message, [String? context]) {
    if (_isDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      print('${_blue}ℹ️ $prefix$message$_reset');
    }
  }

  static void success(String message, [String? context]) {
    if (_isDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      print('${_green}✅ $prefix$message$_reset');
    }
  }

  static void warning(String message, [String? context]) {
    if (_isDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      print('${_yellow}⚠️ $prefix$message$_reset');
    }
  }

  static void error(String message, [String? context, Object? error, StackTrace? stackTrace]) {
    if (_isDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      print('${_red}❌ $prefix$message$_reset');

      if (error != null) {
        print('${_red}   Erro: $error$_reset');
        print('${_red}   Tipo: ${error.runtimeType}$_reset');
      }

      if (stackTrace != null) {
        print('${_red}   Stack trace: $stackTrace$_reset');
      }
    }
  }

  static void debug(String message, [String? context]) {
    if (_isDebugMode) {
      final prefix = context != null ? '[$context] ' : '';
      print('${_cyan}🔧 $prefix$message$_reset');
    }
  }

  // Métodos específicos para Auth
  static void authStart(String operation, String email, [String? additionalInfo]) {
    if (_isDebugMode) {
      print('${_magenta}🔐 === INICIANDO $operation ===$_reset');
      print('${_magenta}   Email: $email$_reset');
      if (additionalInfo != null) {
        print('${_magenta}   Info adicional: $additionalInfo$_reset');
      }
    }
  }

  static void authSuccess(String operation, [String? details]) {
    if (_isDebugMode) {
      print('${_green}✅ === $operation REALIZADO COM SUCESSO ===$_reset');
      if (details != null) {
        print('${_green}   Detalhes: $details$_reset');
      }
    }
  }

  static void authError(String operation, Object error, [StackTrace? stackTrace, String? email]) {
    if (_isDebugMode) {
      print('${_red}❌ === ERRO NO $operation ===$_reset');
      print('${_red}   Erro: $error$_reset');
      print('${_red}   Tipo: ${error.runtimeType}$_reset');

      if (email != null) {
        print('${_red}   Email tentativa: $email$_reset');
      }

      if (stackTrace != null) {
        print('${_red}   Stack trace: $stackTrace$_reset');
      }
    }
  }

  // Método para logs de validação
  static void validationError(String field, String value, String reason) {
    if (_isDebugMode) {
      print('${_yellow}⚠️ Erro de validação:$_reset');
      print('${_yellow}   Campo: $field$_reset');
      print('${_yellow}   Valor: $value$_reset');
      print('${_yellow}   Razão: $reason$_reset');
    }
  }

  // Método para logs de duplicatas
  static void duplicateCheck(String email, String? phone, bool emailExists, bool phoneExists) {
    if (_isDebugMode) {
      print('${_blue}🔍 === VERIFICAÇÃO DE DUPLICATAS ===$_reset');
      print('${_blue}   Email: $email (${emailExists ? 'EXISTE' : 'DISPONÍVEL'})$_reset');
      if (phone != null) {
        print('${_blue}   Telefone: $phone (${phoneExists ? 'EXISTE' : 'DISPONÍVEL'})$_reset');
      }
    }
  }

  // Método para logs de navegação
  static void navigation(String from, String to, [String? reason]) {
    if (_isDebugMode) {
      print('${_cyan}📱 Navegação: $from → $to$_reset');
      if (reason != null) {
        print('${_cyan}   Motivo: $reason$_reset');
      }
    }
  }

  // Método para logs de UI
  static void uiEvent(String event, [Map<String, dynamic>? data]) {
    if (_isDebugMode) {
      print('${_magenta}🎨 UI Event: $event$_reset');
      if (data != null) {
        data.forEach((key, value) {
          print('${_magenta}   $key: $value$_reset');
        });
      }
    }
  }
}