import 'package:conexaoolivia/modules/widgets/custom_button.dart';
import 'package:conexaoolivia/modules/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:email_validator/email_validator.dart';
import 'package:brasil_fields/brasil_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../stores/auth_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authStore = Modular.get<AuthStore>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    try {
      print('📝 === INICIANDO CADASTRO NA UI ===');
      print('   Nome: ${_nameController.text.trim()}');
      print('   Email: ${_emailController.text.trim()}');
      print('   CPF: ${_cpfController.text.trim()}');
      print('   Telefone: ${_phoneController.text.trim()}');
      print('   Validação do formulário...');

      if (_formKey.currentState?.validate() ?? false) {
        print('✅ Formulário válido, processando dados...');

        String? cleanPhone = _phoneController.text.trim().isNotEmpty
            ? UtilBrasilFields.removeCaracteres(_phoneController.text.trim())
            : null;

        String cleanCpf = UtilBrasilFields.removeCaracteres(_cpfController.text.trim());

        print('📱 Telefone limpo: ${cleanPhone ?? 'nenhum'}');
        print('🆔 CPF limpo: $cleanCpf');
        print('🚀 Chamando AuthStore.signUp...');

        final success = await _authStore.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          cpf: cleanCpf,
          phone: cleanPhone,
        );

        if (success && mounted) {
          print('✅ Cadastro realizado com sucesso na UI');
          _showSuccessDialog();
        } else {
          print('❌ Cadastro falhou na UI');
          if (_authStore.errorMessage != null) {
            print('   Mensagem de erro: ${_authStore.errorMessage}');
          }
        }
      } else {
        print('❌ Formulário inválido, não prosseguindo');

        // Log dos erros de validação
        final formState = _formKey.currentState;
        if (formState != null) {
          print('   Detalhes da validação:');
          if (_nameController.text.trim().isEmpty) {
            print('     - Nome vazio');
          }
          if (_emailController.text.trim().isEmpty) {
            print('     - Email vazio');
          }
          if (!EmailValidator.validate(_emailController.text.trim())) {
            print('     - Email inválido: ${_emailController.text.trim()}');
          }
          if (_cpfController.text.trim().isEmpty) {
            print('     - CPF vazio');
          }
          if (!CPFValidator.isValid(_cpfController.text.trim())) {
            print('     - CPF inválido: ${_cpfController.text.trim()}');
          }
          if (_passwordController.text.isEmpty) {
            print('     - Senha vazia');
          }
          if (_passwordController.text != _confirmPasswordController.text) {
            print('     - Senhas não coincidem');
          }
        }
      }
    } catch (e, stackTrace) {
      print('❌ === ERRO INESPERADO NO CADASTRO UI ===');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      print('   Widget mounted: $mounted');
      print('   Dados do formulário:');
      print('     Nome: ${_nameController.text}');
      print('     Email: ${_emailController.text}');
      print('     CPF: ${_cpfController.text}');
      print('     Telefone: ${_phoneController.text}');

      // Mostrar erro genérico para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro inesperado no cadastro. Tente novamente.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            // ✅ CORREÇÃO: Usar Expanded para evitar overflow
            Expanded(
              child: Text(
                'Cadastro realizado!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: const Text(
          'Sua conta foi criada com sucesso. Você já pode fazer login.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Modular.to.pushReplacementNamed('/auth/login');
            },
            child: const Text('Fazer Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo gradiente em 100% da tela
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Conteúdo
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Logo
                  Container(
                    width: 120,
                    height: 120,
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

                  const SizedBox(height: 10),

                  Text(
                    'Criar Conta',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Preencha os dados abaixo',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  // Card com formulário
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              label: 'Nome completo',
                              prefixIcon: Icons.person_outline,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Digite seu nome';
                                }
                                if (value!.length < 3) {
                                  return 'Nome deve ter pelo menos 3 caracteres';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

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
                              controller: _cpfController,
                              label: 'CPF',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.badge_outlined,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CpfInputFormatter(),
                              ],
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Digite seu CPF';
                                }
                                if (!CPFValidator.isValid(value!)) {
                                  return 'Digite um CPF válido';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _phoneController,
                              label: 'Telefone',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TelefoneInputFormatter(),
                              ],
                              validator: (value) {
                                if (value != null && value.trim().isNotEmpty) {
                                  String cleanPhone = UtilBrasilFields.removeCaracteres(value);
                                  if (cleanPhone.length < 10 || cleanPhone.length > 11) {
                                    return 'Digite um telefone válido';
                                  }
                                  if (cleanPhone.length == 11 && cleanPhone[2] != '9') {
                                    return 'Celular deve começar com 9 após o DDD';
                                  }
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
                                if (value!.length < 6) {
                                  return 'Senha deve ter pelo menos 6 caracteres';
                                }
                                if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                                  return 'Senha deve conter pelo menos uma letra e um número';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirmar senha',
                              obscureText: _obscureConfirmPassword,
                              prefixIcon: Icons.lock_outline,
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
                                  return 'Confirme sua senha';
                                }
                                if (value != _passwordController.text) {
                                  return 'Senhas não coincidem';
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
                                      style: const TextStyle(color: AppColors.error),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            Observer(
                              builder: (_) => CustomButton(
                                text: 'Criar Conta',
                                onPressed: _handleRegister,
                                isLoading: _authStore.isLoading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já tem uma conta? '),
                      TextButton(
                        onPressed: () {
                          Modular.to.pop();
                        },
                        child: const Text(
                          'Entrar',
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