// modules/profiles/pages/profile_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'profile_form_store.dart';
import 'profile_store.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late final ProfileStore profileStore;

  @override
  void initState() {
    super.initState();
    profileStore = Modular.get<ProfileStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: const Text(
          'Detalhes do Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Modular.to.pop(),
        ),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) {
              final profile = profileStore.selectedProfile;
              final canEdit = profile != null &&
                  (profileStore.isAdmin || profileStore.isCurrentUser(profile.id));

              return canEdit
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _editProfile,
                  ),
                  if (profileStore.isAdmin && !profileStore.isCurrentUser(profile!.id))
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: _confirmDeleteProfile,
                    ),
                ],
              )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final profile = profileStore.selectedProfile;

          if (profile == null) {
            return const Center(
              child: Text(
                'Perfil não encontrado',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (profileStore.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B6F9B)),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(profile),
                const SizedBox(height: 30),
                _buildContent(profile),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(profile) {
    final isCurrentUser = profileStore.isCurrentUser(profile.id);

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? Image.network(
                  profile.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(profile),
                )
                    : _buildAvatarPlaceholder(profile),
              ),
            ),
            const SizedBox(height: 16),

            // Nome
            Text(
              profile.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (isCurrentUser)
                  _buildHeaderBadge('Seu Perfil', Colors.white, const Color(0xFF8B6F9B)),
                if (profile.isAdmin)
                  _buildHeaderBadge('Administrador', Colors.purple.shade100, Colors.purple),
                if (profile.needsPasswordChange)
                  _buildHeaderBadge('Trocar Senha', Colors.orange.shade100, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(profile) {
    final initials = _getInitials(profile.displayName);
    return Container(
      color: const Color(0xFF8B6F9B).withOpacity(0.1),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Color(0xFF8B6F9B),
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildContent(profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informações de contato
          _buildInfoCard(
            title: 'Informações de Contato',
            icon: Icons.contact_mail,
            children: [
              _buildInfoRow(Icons.email, 'Email', profile.email),
              if (profile.phone != null && profile.phone!.isNotEmpty)
                _buildInfoRow(Icons.phone, 'Telefone', profile.formattedPhone),
            ],
          ),
          const SizedBox(height: 16),

          // Documentação
          if (profile.cpf != null && profile.cpf!.isNotEmpty) ...[
            _buildInfoCard(
              title: 'Documentação',
              icon: Icons.badge,
              children: [
                _buildInfoRow(Icons.credit_card, 'CPF', profile.formattedCpf),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Observações (apenas para admin)
          if (profileStore.isAdmin && profile.observacoes != null && profile.observacoes!.isNotEmpty) ...[
            _buildInfoCard(
              title: 'Observações',
              icon: Icons.notes,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    profile.observacoes!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Informações do sistema (apenas para admin)
          if (profileStore.isAdmin) ...[
            _buildInfoCard(
              title: 'Informações do Sistema',
              icon: Icons.admin_panel_settings,
              children: [
                _buildInfoRow(
                  Icons.calendar_today,
                  'Cadastrado em',
                  profile.getFormattedCreatedDate(),
                ),
                profile.isAdmin ?
                _buildSwitchRow(
                  Icons.admin_panel_settings,
                  'Administrador',
                  profile.isAdmin,
                ) : SizedBox(),
                _buildSwitchRow(
                  Icons.lock_reset,
                  'Exige trocar senha',
                  profile.needsPasswordChange,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8B6F9B), size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B6F9B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(IconData icon, String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: value ? Colors.green.withOpacity(0.15) : Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'Sim' : 'Não',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: value ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  void _editProfile() {
    final formStore = Modular.get<ProfileFormStore>();
    formStore.initializeWithProfile(
      profileStore.selectedProfile!,
      profileStore.isAdmin,
    );
    Modular.to.pushNamed('/profiles/form').then((_) {
      profileStore.loadProfiles();
    });
  }

  void _confirmDeleteProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este perfil? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deleteProfile() async {
    final success = await profileStore.deleteProfile(profileStore.selectedProfile!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil excluído com sucesso!'),
          backgroundColor: Color(0xFF8B6F9B),
        ),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileStore.errorMessage ?? 'Erro ao excluir perfil'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}