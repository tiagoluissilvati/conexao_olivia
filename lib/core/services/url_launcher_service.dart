// services/url_launcher_service.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class UrlLauncherService {
  /// Abre uma URL no navegador
  /// Funciona para Android, iOS e Web
  static Future<bool> openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Verifica se pode abrir a URL
      if (await canLaunchUrl(uri)) {
        // Para Web: sempre abre em nova aba
        if (kIsWeb) {
          return await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
            webOnlyWindowName: '_blank',
          );
        }
        // Para Mobile: abre no navegador externo
        else {
          return await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao abrir URL: $e');
      return false;
    }
  }

  /// Abre telefone
  static Future<bool> makePhoneCall(String phoneNumber) async {
    try {
      final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao fazer ligação: $e');
      return false;
    }
  }

  /// Envia SMS
  static Future<bool> sendSMS(String phoneNumber, {String? message}) async {
    try {
      final Uri uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: message != null ? {'body': message} : null,
      );
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao enviar SMS: $e');
      return false;
    }
  }

  /// Envia email
  static Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      final Uri uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao enviar email: $e');
      return false;
    }
  }
}