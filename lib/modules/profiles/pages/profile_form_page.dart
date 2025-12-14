// modules/profiles/pages/profile_form_page.dart
import 'package:conexaoolivia/modules/auth/stores/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../widgets/custom_text_field.dart';
import 'profile_form_store.dart';
import 'profile_store.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({Key? key}) : super(key: key);

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _observacoesController = TextEditingController();

  late final ProfileStore profileStore;
  late final ProfileFormStore formStore;

  @override
  void initState() {
    super.initState();
    profileStore = Modular.get<ProfileStore>();
    formStore = Modular.get<ProfileFormStore>();
    _setupControllers();
  }

  void _setupControllers() {
    _nameController.text = formStore.name;
    _emailController.text = formStore.email;
    _phoneController.text = formStore.formatPhone(formStore.phone);
    _cpfController.text = formStore.formatCpf(formStore.cpf);
    _observacoesController.text = formStore.observacoes;

    _nameController.addListener(() => formStore.setName(_nameController.text));
    _emailController.addListener(() => formStore.setEmail(_emailController.text));
    _phoneController.addListener(() {
      final formatted = _formatPhoneInput(_phoneController.text);
      if (formatted != _phoneController.text) {
        _phoneController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      formStore.setPhone(_phoneController.text);
    });
    _cpfController.addListener(() {
      final formatted = _formatCpfInput(_cpfController.text);
      if (formatted != _cpfController.text) {
        _cpfController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      formStore.setCpf(_cpfController.text);
    });
    _observacoesController.addListener(() => formStore.setObservacoes(_observacoesController.text));
  }

  String _formatPhoneInput(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length <= 10) {
      if (cleaned.length <= 2) return cleaned;
      if (cleaned.length <= 6) {
        return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2)}';
      }
      return '(${cleaned.substring(0, 2)}) ${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
    } else {
      final limited = cleaned.substring(0, 11);
      return '(${limited.substring(0, 2)}) ${limited.substring(2, 7)}-${limited.substring(7)}';
    }
  }

  String _formatCpfInput(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length <= 11) {
      if (cleaned.length <= 3) return cleaned;
      if (cleaned.length <= 6) {
        return '${cleaned.substring(0, 3)}.${cleaned.substring(3)}';
      }
      if (cleaned.length <= 9) {
        return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6)}';
      }
      return '${cleaned.substring(0, 3)}.${cleaned.substring(3, 6)}.${cleaned.substring(6, 9)}-${cleaned.substring(9)}';
    }
    return value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _observacoesController.dispose();
    formStore.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackPress();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF8B6F9B),
          title: const Text(
            'Editar Perfil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _handleBackPress,
          ),
          elevation: 0,
        ),
        body: Observer(
          builder: (_) => Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF8B6F9B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Nome
            _buildFormCard(
              title: 'Nome Completo',
              child: CustomTextField(
                controller: _nameController,
                label: '',
                hint: 'Digite o nome completo',
                textCapitalization: TextCapitalization.words,
                validator: formStore.validateName,
              ),
            ),
            const SizedBox(height: 16),

            // Email
            _buildFormCard(
              title: 'Email',
              child: CustomTextField(
                controller: _emailController,
                label: '',
                hint: 'Digite o email',
                keyboardType: TextInputType.emailAddress,
                enabled: false, // Email não pode ser alterado
                validator: formStore.validateEmail,
              ),
            ),
            const SizedBox(height: 16),

            // Telefone
            _buildFormCard(
              title: 'Telefone (Opcional)',
              child: CustomTextField(
                controller: _phoneController,
                label: '',
                hint: '(00) 00000-0000',
                keyboardType: TextInputType.phone,
                validator: formStore.validatePhone,
              ),
            ),
            const SizedBox(height: 16),

            // CPF
            _buildFormCard(
              title: 'CPF (Opcional)',
              child: CustomTextField(
                controller: _cpfController,
                label: '',
                hint: '000.000.000-00',
                keyboardType: TextInputType.number,
                validator: formStore.validateCpf,
              ),
            ),
            const SizedBox(height: 16),

            // Observações (apenas para admin)
            if (formStore.isCurrentUserAdmin) ...[
              _buildFormCard(
                title: 'Observações (Opcional)',
                child: CustomTextField(
                  controller: _observacoesController,
                  label: '',
                  hint: 'Adicione observações sobre o usuário',
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Campos Admin (apenas visível para admins)
            if (formStore.isCurrentUserAdmin) ...[
              _buildFormCard(
                title: 'Permissões',
                child: Column(
                  children: [
                    Observer(
                      builder: (_) => CheckboxListTile(
                        title: const Text('Administrador'),
                        subtitle: const Text('Usuário terá acesso total ao sistema'),
                        value: formStore.isAdmin,
                        onChanged: (value) => formStore.setIsAdmin(value ?? false),
                        activeColor: const Color(0xFF8B6F9B),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const Divider(),
                    Observer(
                      builder: (_) => CheckboxListTile(
                        title: const Text('Exige trocar senha'),
                        subtitle: const Text('Usuário será obrigado a trocar a senha no próximo login'),
                        value: formStore.needsPasswordChange,
                        onChanged: (value) => formStore.setNeedsPasswordChange(value ?? false),
                        activeColor: const Color(0xFF8B6F9B),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Data de cadastro
            if (formStore.editingProfile != null) ...[
              _buildFormCard(
                title: 'Data de Cadastro',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF8B6F9B), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        formStore.editingProfile!.getFormattedCreatedDate(),
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botão salvar
            Observer(
              builder: (_) => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: formStore.isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6F9B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: formStore.isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : const Text(
                    'Salvar Alterações',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botão Excluir Minha Conta (apenas para próprio usuário)
            if (!formStore.isCurrentUserAdmin ||
                (formStore.editingProfile != null &&
                    profileStore.isCurrentUser(formStore.editingProfile!.id))) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: formStore.isLoading ? null : _confirmDeleteAccount,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Excluir Minha Conta'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Esta ação é permanente e não pode ser desfeita',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Mostrar erro
            Observer(
              builder: (_) => formStore.hasError
                  ? Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formStore.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B6F9B),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formStore.isFormValid) {
      formStore.setError('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    formStore.setLoading(true);

    try {
      final profile = formStore.buildProfile();
      final success = await profileStore.updateProfile(profile);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Color(0xFF8B6F9B),
          ),
        );
        Modular.to.pop();
      } else {
        formStore.setError(profileStore.errorMessage ?? 'Erro ao salvar perfil');
      }
    } catch (e) {
      formStore.setError('Erro inesperado: $e');
    } finally {
      formStore.setLoading(false);
    }
  }

  void _handleBackPress() {
    if (formStore.hasPendingChanges) {
      _showExitConfirmation();
    } else {
      formStore.clearForm();
      Modular.to.pop();
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text('Você tem alterações não salvas. Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              formStore.clearForm();
              Modular.to.pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Excluir Conta',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Você está prestes a excluir permanentemente sua conta e todos os dados associados.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Esta ação é irreversível',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Todos os seus dados pessoais serão excluídos\n'
                        '• Você perderá acesso imediato ao aplicativo\n'
                        '• Esta operação não pode ser desfeita',
                    style: TextStyle(fontSize: 13, color: Colors.red.shade900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tem certeza absoluta que deseja continuar?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, Excluir Permanentemente'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    formStore.setLoading(true);

    try {
      final profileId = formStore.editingProfile!.id;
      final success = await profileStore.deleteProfile(profileId);

      if (success) {
        // Mostrar mensagem de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta excluída com sucesso'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Fazer logout e redirecionar para tela de login
        final authStore = Modular.get<AuthStore>();
        await authStore.signOut();

        // Aguardar um momento antes de redirecionar
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Modular.to.navigate('/auth/login');
        }
      } else {
        formStore.setError(
          profileStore.errorMessage ?? 'Erro ao excluir conta. Tente novamente.',
        );
      }
    } catch (e) {
      formStore.setError('Erro inesperado ao excluir conta: $e');
    } finally {
      formStore.setLoading(false);
    }
  }
}