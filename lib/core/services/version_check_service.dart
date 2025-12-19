import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/supabase_service.dart';
import '../../modules/auth/models/app_version_model.dart';

enum VersionStatus {
  upToDate,      // Versão atual, não precisa atualizar
  updateAvailable, // Atualização disponível mas não obrigatória
  updateRequired,  // Atualização obrigatória
}

class VersionCheckResult {
  final VersionStatus status;
  final AppVersionModel? serverVersion;
  final String? currentVersion;
  final int? currentVersionCode;
  final String? message;

  VersionCheckResult({
    required this.status,
    this.serverVersion,
    this.currentVersion,
    this.currentVersionCode,
    this.message,
  });

  bool get needsUpdate =>
      status == VersionStatus.updateRequired ||
          status == VersionStatus.updateAvailable;

  bool get isForceUpdate => status == VersionStatus.updateRequired;
}

class VersionCheckService {
  /// Verifica se o app precisa ser atualizado
  static Future<VersionCheckResult> checkVersion() async {
    try {
      print('📱 === VERIFICANDO VERSÃO DO APP ===');

      // 1. Obter informações do app atual
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersionName = packageInfo.version;
      final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      print('   Versão atual: $currentVersionName (code: $currentVersionCode)');

      // 2. Determinar plataforma
      final platform = Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'all';
      print('   Plataforma: $platform');

      // 3. Buscar versão do servidor
      print('🔍 Buscando versão no servidor...');
      final response = await SupabaseService.client
          .rpc('get_latest_app_version', params: {'p_platform': platform})
          .select()
          .single();

      print('📡 Resposta do servidor: $response');

      final serverVersion = AppVersionModel.fromJson(response);
      print('   Versão servidor: ${serverVersion.versionName} (code: ${serverVersion.versionCode})');
      print('   Versão mínima obrigatória: ${serverVersion.minRequiredVersionCode}');
      print('   Force update: ${serverVersion.isForceUpdate}');

      // 4. Comparar versões
      VersionStatus status;
      String? message;

      if (currentVersionCode < serverVersion.minRequiredVersionCode) {
        // Versão atual é menor que a mínima obrigatória
        status = VersionStatus.updateRequired;
        message = serverVersion.updateMessage ??
            'Esta versão do app não é mais suportada. Por favor, atualize para continuar usando.';
        print('❌ ATUALIZAÇÃO OBRIGATÓRIA');
      } else if (serverVersion.isForceUpdate && currentVersionCode < serverVersion.versionCode) {
        // Existe uma versão mais nova e está marcada como obrigatória
        status = VersionStatus.updateRequired;
        message = serverVersion.updateMessage ??
            'Uma atualização importante está disponível. Por favor, atualize para continuar.';
        print('⚠️ ATUALIZAÇÃO FORÇADA');
      } else if (currentVersionCode < serverVersion.versionCode) {
        // Existe uma versão mais nova mas não é obrigatória
        status = VersionStatus.updateAvailable;
        message = serverVersion.updateMessage ??
            'Uma nova versão está disponível! Atualize para obter as últimas melhorias.';
        print('ℹ️ Atualização disponível (opcional)');
      } else {
        // App está na versão mais recente
        status = VersionStatus.upToDate;
        message = null;
        print('✅ APP ATUALIZADO');
      }

      print('✅ === VERIFICAÇÃO CONCLUÍDA ===');

      return VersionCheckResult(
        status: status,
        serverVersion: serverVersion,
        currentVersion: currentVersionName,
        currentVersionCode: currentVersionCode,
        message: message,
      );

    } catch (e, stackTrace) {
      print('❌ === ERRO NA VERIFICAÇÃO DE VERSÃO ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');

      // Em caso de erro, permitir que o app continue
      // (pode ser problema de conexão, tabela não existe ainda, etc.)
      return VersionCheckResult(
        status: VersionStatus.upToDate,
        message: null,
      );
    }
  }

  /// Abre a loja de apps para atualização
  static Future<void> openStore(BuildContext context) async {
    try {
      print('🛒 Tentando abrir loja...');

      // Buscar URLs da loja
      final platform = Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'all';
      final response = await SupabaseService.client
          .rpc('get_latest_app_version', params: {'p_platform': platform})
          .select()
          .single();

      final serverVersion = AppVersionModel.fromJson(response);

      String? storeUrl;
      if (Platform.isAndroid && serverVersion.storeUrlAndroid != null) {
        storeUrl = serverVersion.storeUrlAndroid;
      } else if (Platform.isIOS && serverVersion.storeUrlIos != null) {
        storeUrl = serverVersion.storeUrlIos;
      }

      if (storeUrl != null && storeUrl.isNotEmpty) {
        print('📱 Abrindo URL: $storeUrl');

        final uri = Uri.parse(storeUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          print('✅ Loja aberta com sucesso');
        } else {
          print('❌ Não foi possível abrir a loja');
          _showManualUpdateDialog(context);
        }
      } else {
        // URL não configurada - mostrar diálogo informativo
        print('⚠️ URL da loja não configurada');
        _showManualUpdateDialog(context);
      }

    } catch (e) {
      print('❌ Erro ao abrir loja: $e');
      // Em caso de erro, também mostrar diálogo manual
      _showManualUpdateDialog(context);
    }
  }

  /// Diálogo para orientar atualização manual
  static void _showManualUpdateDialog(BuildContext context) {
    final storeName = Platform.isAndroid ? 'Google Play Store' : 'App Store';
    final storeIcon = Platform.isAndroid ? '🤖' : '🍎';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                storeIcon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Atualização Necessária',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Por favor, atualize o aplicativo manualmente através da $storeName.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Busque por "Conexão Olivia" na $storeName e instale a versão mais recente.',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }
}