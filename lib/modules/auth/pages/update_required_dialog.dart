import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/version_check_service.dart';
import '../../widgets/custom_button.dart';

class UpdateRequiredDialog extends StatelessWidget {
  final VersionCheckResult versionResult;

  const UpdateRequiredDialog({
    super.key,
    required this.versionResult,
  });

  @override
  Widget build(BuildContext context) {
    final isForceUpdate = versionResult.isForceUpdate;

    return WillPopScope(
      // Bloquear botão voltar se for update obrigatório
      onWillPop: () async => !isForceUpdate,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:  AppColors.info.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon( Icons.system_update_rounded,
                  size: 40,
                  color:  AppColors.info,
                ),
              ),

              const SizedBox(height: 24),

              // Título
              Text(  'Atualização Disponível',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isForceUpdate ? AppColors.error : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Mensagem
              Text(
                versionResult.message ??
                    'Uma nova versão do app está disponível.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyDark,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Informações de versão
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greyLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildVersionRow(
                      'Versão atual:',
                      '${versionResult.currentVersion} (${versionResult.currentVersionCode})',
                      Icons.phone_android,
                    ),
                    const SizedBox(height: 8),
                    _buildVersionRow(
                      'Versão disponível:',
                      '${versionResult.serverVersion?.versionName} (${versionResult.serverVersion?.versionCode})',
                      Icons.cloud_download,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botões
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botão de atualizar
                  CustomButton(
                    text: 'Atualizar Agora',
                    onPressed: () async {
                      await VersionCheckService.openStore();

                      // Se não for obrigatório, permitir fechar
                      if (!isForceUpdate && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icons.download_rounded,
                  ),

                  // Botão de fechar (apenas se não for obrigatório)
                  if (!isForceUpdate) ...[
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Agora Não',
                      onPressed: () => Navigator.of(context).pop(),
                      isOutlined: true,
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Fechar o app
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else {
                          exit(0);
                        }
                      },
                      child: Text(
                        'Sair do App',
                        style: TextStyle(
                          color: AppColors.greyDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Aviso se for update obrigatório
              if (isForceUpdate) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Esta atualização é obrigatória para continuar usando o app.',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionRow(
      String label,
      String value,
      IconData icon, {
        bool isHighlighted = false,
      }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlighted ? AppColors.primary : AppColors.greyDark,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.greyDark,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  color: isHighlighted ? AppColors.primary : AppColors.greyDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}