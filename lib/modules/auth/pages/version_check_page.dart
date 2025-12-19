import 'package:conexaoolivia/modules/auth/pages/update_required_dialog.dart';
import 'package:conexaoolivia/modules/auth/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/version_check_service.dart';

class VersionCheckPage extends StatefulWidget {
  const VersionCheckPage({super.key});

  @override
  State<VersionCheckPage> createState() => _VersionCheckPageState();
}

class _VersionCheckPageState extends State<VersionCheckPage> {
  bool _isChecking = true;
  String _statusMessage = 'Verificando versão do app...';

  final _authStore = Modular.get<AuthStore>();
  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    try {
      setState(() {
        _isChecking = true;
        _statusMessage = 'Verificando versão do app...';
      });

      // Pequeno delay para mostrar a tela (opcional, para UX)
      await Future.delayed(const Duration(milliseconds: 500));

      print('🔍 Iniciando verificação de versão...');
      final result = await VersionCheckService.checkVersion();

      if (!mounted) return;

      if (result.needsUpdate) {
        print('⚠️ Atualização necessária, mostrando dialog...');

        // Mostrar dialog de atualização
        final shouldContinue = await showDialog<bool>(
          context: context,
          barrierDismissible: !result.isForceUpdate,
          builder: (context) => UpdateRequiredDialog(versionResult: result),
        );

        // Se for update obrigatório e não aceitou, não continua
        if (result.isForceUpdate && (shouldContinue == null || !shouldContinue)) {
          print('❌ Update obrigatório não aceito, mantendo na tela');
          setState(() {
            _statusMessage = 'Aguardando atualização...';
          });
          return;
        }
      }

      // App está atualizado ou usuário optou por continuar
      if (mounted) {

        // Navegar para tela apropriada
        if (mounted) {

          Modular.to.pushReplacementNamed('/home');
        }
      }

    } catch (e, stackTrace) {
      print('❌ Erro na verificação: $e');
      print('Stack trace: $stackTrace');

      // Em caso de erro, permitir continuar (pode ser problema de conexão)
      if (mounted) {
        setState(() {
          _statusMessage = 'Erro ao verificar versão. Continuando...';
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Modular.to.pushReplacementNamed('/auth/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/conexao_olivia.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: AppColors.white,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Loading indicator
              if (_isChecking) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
                const SizedBox(height: 24),
              ],

              // Status message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              // Versão do app
              FutureBuilder<String>(
                future: _getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'v${snapshot.data}',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      return '1.0.0';
    }
  }
}

// Não esqueça de adicionar o import no topo do arquivo:
// import 'package:package_info_plus/package_info_plus.dart';