import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../stores/auth_store.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('🔐 === INICIANDO TROCA DE SENHA ===');
      print('   User ID: ${_authStore.currentUser?.id}');

      final success = await _authStore.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (success && mounted) {
        print('✅ Senha alterada com sucesso');

        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha alterada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Fechar dialog e ir para home
        Navigator.of(context).pop();
        Modular.to.pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = _authStore.errorMessage ?? 'Erro ao alterar senha';
        });
      }
    } catch (e) {
      print('❌ Erro ao alterar senha: $e');
      setState(() {
        _errorMessage = 'Erro inesperado. Tente novamente.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Impede fechar o dialog apertando "voltar"
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícone e título
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warning,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Troca de senha obrigatória',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Por segurança, crie uma nova senha',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.greyDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Aviso
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Você está usando uma senha temporária. Crie uma senha segura para continuar.',
                            style: TextStyle(
                              color: AppColors.info,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Senha atual
                  CustomTextField(
                    controller: _currentPasswordController,
                    label: 'Senha atual (temporária)',
                    obscureText: _obscureCurrentPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Digite a senha atual';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Nova senha
                  CustomTextField(
                    controller: _newPasswordController,
                    label: 'Nova senha',
                    obscureText: _obscureNewPassword,
                    prefixIcon: Icons.lock_reset,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Digite a nova senha';
                      }
                      if (value!.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      if (value == _currentPasswordController.text) {
                        return 'A nova senha deve ser diferente da atual';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirmar senha
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar nova senha',
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock_sharp,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Confirme a nova senha';
                      }
                      if (value != _newPasswordController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Botão de confirmar
                  CustomButton(
                    text: 'Alterar senha',
                    onPressed: _handleChangePassword,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 12),

                  // Dicas de senha segura
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dicas para uma senha segura:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.greyDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPasswordTip('• Use pelo menos 6 caracteres'),
                        _buildPasswordTip('• Misture letras e números'),
                        _buildPasswordTip('• Evite informações pessoais'),
                        _buildPasswordTip('• Use caracteres especiais'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.greyDark,
        ),
      ),
    );
  }
}