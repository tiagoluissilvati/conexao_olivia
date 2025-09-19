import 'package:conexaoolivia/modules/widgets/custom_button.dart';
import 'package:conexaoolivia/modules/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:email_validator/email_validator.dart';
import '../../../core/theme/app_colors.dart';
import '../stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    try {
      print('🔐 === INICIANDO LOGIN NA UI ===');
      print('   Email: ${_emailController.text.trim()}');
      print('   Validação do formulário...');

      if (_formKey.currentState?.validate() ?? false) {
        print('✅ Formulário válido, prosseguindo...');

        final email = _emailController.text.trim();
        final password = _passwordController.text;

        print('🚀 Chamando AuthStore.signIn...');
        final success = await _authStore.signIn(
          email: email,
          password: password,
        );

        if (success && mounted) {
          print('✅ Login realizado com sucesso, redirecionando para /home');
          Modular.to.pushReplacementNamed('/home');
        } else {
          print('❌ Login falhou');
          if (_authStore.errorMessage != null) {
            print('   Mensagem de erro: ${_authStore.errorMessage}');
          }
        }
      } else {
        print('❌ Formulário inválido, não prosseguindo');
      }
    } catch (e, stackTrace) {
      print('❌ === ERRO INESPERADO NO LOGIN UI ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   Widget mounted: $mounted');

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
      body: Stack(
        children: [
          // Fundo com gradiente ocupando 100% da tela
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Conteúdo da tela
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Logo com imagem
                  Container(
                    width: 180,
                    height: 180,
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
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.people_alt_rounded,
                              color: AppColors.white,
                              size: 60,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Card de login
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Entrar',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 24),

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

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _passwordController,
                              label: 'Senha',
                              obscureText: _obscurePassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Digite sua senha';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  _authStore.errorMessage = null;
                                  Modular.to.pushNamed('/auth/forgot-password');
                                },
                                child: const Text('Esqueceu a senha?'),
                              ),
                            ),

                            const SizedBox(height: 16),

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
                                        color: AppColors.error,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            Observer(
                              builder: (_) => CustomButton(
                                text: 'Entrar',
                                onPressed: _handleLogin,
                                isLoading: _authStore.isLoading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem uma conta? '),
                      TextButton(
                        onPressed: () {
                          _authStore.errorMessage = null;
                          Modular.to.pushNamed('/auth/register');
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
