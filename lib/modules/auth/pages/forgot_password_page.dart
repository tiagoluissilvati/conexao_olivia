import 'package:conexaoolivia/modules/widgets/custom_button.dart';
import 'package:conexaoolivia/modules/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:email_validator/email_validator.dart';
import '../../../core/theme/app_colors.dart';
import '../stores/auth_store.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();
  bool _passwordReset = false;

  @override
  void initState() {
    super.initState();
    _authStore.initializeAdminService();
    print('🔑 ForgotPasswordPage inicializada');
  }

  @override
  void dispose() {
    print('🔑 ForgotPasswordPage sendo descartada');
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    try {
      print('🔑 === INICIANDO RESET DE SENHA NA UI ===');
      print('   Email: ${_emailController.text.trim()}');
      print('   Validação do formulário...');

      if (_formKey.currentState?.validate() ?? false) {
        print('✅ Formulário válido, prosseguindo...');

        final email = _emailController.text.trim();
        print('🚀 Chamando AuthStore.resetPassword...');

        final success = await _authStore.resetPassword(email);

        if (success) {
          print('✅ Reset de senha realizado com sucesso na UI');
          setState(() {
            _passwordReset = true;
          });
        } else {
          print('❌ Reset de senha falhou na UI');
          if (_authStore.errorMessage != null) {
            print('   Mensagem de erro: ${_authStore.errorMessage}');
          }
        }
      } else {
        print('❌ Formulário inválido, não prosseguindo');

        // Log dos erros de validação específicos
        final email = _emailController.text.trim();
        if (email.isEmpty) {
          print('   - Email vazio');
        } else if (!EmailValidator.validate(email)) {
          print('   - Email inválido: $email');
        }
      }
    } catch (e, stackTrace) {
      print('❌ === ERRO INESPERADO NO RESET DE SENHA UI ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   Widget mounted: $mounted');
      print('   Email tentativa: ${_emailController.text.trim()}');

      // Mostrar erro genérico para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro inesperado. Tente novamente.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Adiciona resizeToAvoidBottomInset para lidar com o teclado
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Usa Flexible ao invés de Expanded para permitir que o conteúdo se ajuste
                Flexible(
                  child: SingleChildScrollView(
                    // Adiciona padding bottom quando o teclado está visível
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ConstrainedBox(
                      // Garante que o conteúdo ocupe pelo menos a altura disponível
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            48 - // padding total (24 * 2)
                            80, // altura aproximada do botão "Voltar ao login" + espaçamento
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ícone
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _passwordReset ? AppColors.success : AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_passwordReset
                                      ? AppColors.success
                                      : AppColors.primary)
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              _passwordReset
                                  ? Icons.check_circle_outline
                                  : Icons.lock_reset,
                              color: AppColors.white,
                              size: 50,
                            ),
                          ),

                          const SizedBox(height: 32),

                          if (!_passwordReset) ...[
                            Text(
                              'Esqueceu sua senha?',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'Digite seu email para redefinir sua senha.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: AppColors.greyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 48),

                            Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: _emailController,
                                        label: 'Email',
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: Icons.email_outlined,
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Digite seu email';
                                          }
                                          if (!EmailValidator.validate(value!)) {
                                            return 'Digite um email válido';
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 24),

                                      Observer(
                                        builder: (_) {
                                          if (_authStore.errorMessage != null) {
                                            return Container(
                                              padding: const EdgeInsets.all(12),
                                              margin: const EdgeInsets.only(bottom: 16),
                                              decoration: BoxDecoration(
                                                color: AppColors.error.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _authStore.errorMessage!,
                                                style: const TextStyle(
                                                    color: AppColors.error),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),

                                      Observer(
                                        builder: (_) => CustomButton(
                                          text: 'Redefinir senha',
                                          onPressed: _handleResetPassword,
                                          isLoading: _authStore.isLoading,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Senha redefinida!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                color: AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'Sua senha foi redefinida com sucesso.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: AppColors.greyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.success.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.success,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nova senha temporária:',
                                        style: TextStyle(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Primeiros 6 dígitos do seu CPF',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Use esta senha para fazer login. Recomendamos alterar sua senha após o primeiro acesso.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.greyDark,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                CustomButton(
                  text: 'Voltar ao login',
                  onPressed: () => Modular.to.pop(),
                  isOutlined: true,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}