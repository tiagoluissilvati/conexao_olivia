import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/profile_model.dart';
import 'profile_store.dart';

class ProfilesListPage extends StatefulWidget {
  const ProfilesListPage({Key? key}) : super(key: key);

  @override
  State<ProfilesListPage> createState() => _ProfilesListPageState();
}

class _ProfilesListPageState extends State<ProfilesListPage> {
  late final ProfileStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get<ProfileStore>();
    store.loadProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: const Text(
          'Perfis de Usuários',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B6F9B)),
            );
          }

          if (store.hasError) {
            return _buildErrorState();
          }

          return Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProfilesList(),
            ],
          );
        },
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Observer(
              builder: (_) => Text(
                '${store.profiles.length} ${store.profiles.length == 1 ? "usuário" : "usuários"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesList() {
    return Expanded(
      child: Observer(
        builder: (_) {
          if (!store.hasProfiles) {
            return const Center(
              child: Text(
                'Nenhum perfil encontrado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: store.profiles.length,
            itemBuilder: (context, index) {
              final profile = store.profiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProfileCard(profile),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(Profile profile) {
    final isCurrentUser = store.isCurrentUser(profile.id);

    return GestureDetector(
      onTap: () => _navigateToProfileDetail(profile),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isCurrentUser
              ? Border.all(color: const Color(0xFF8B6F9B), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6F9B).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B6F9B).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    profile.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(profile),
                  ),
                )
                    : _buildAvatarPlaceholder(profile),
              ),
              const SizedBox(width: 16),
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8B6F9B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B6F9B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Você',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (profile.isAdmin) ...[
                          _buildBadge('Admin', Colors.purple),
                          const SizedBox(width: 8),
                        ],
                        if (profile.needsPasswordChange) ...[
                          _buildBadge('Trocar Senha', Colors.orange),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8B6F9B),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(Profile profile) {
    final initials = _getInitials(profile.displayName);
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xFF8B6F9B),
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              store.errorMessage ?? 'Erro desconhecido',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              store.clearError();
              store.loadProfiles();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B6F9B),
            ),
            child: const Text(
              'Tentar Novamente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfileDetail(Profile profile) {
    store.setSelectedProfile(profile);
    Modular.to.pushNamed('/profiles/detail');
  }
}