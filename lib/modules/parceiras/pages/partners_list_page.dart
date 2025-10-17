// modules/parceiras/pages/partners_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/partner_model.dart';
import 'partner_store.dart';

class PartnersListPage extends StatefulWidget {
  const PartnersListPage({Key? key}) : super(key: key);

  @override
  State<PartnersListPage> createState() => _PartnersListPageState();
}

class _PartnersListPageState extends State<PartnersListPage> {
  late final PartnerStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get<PartnerStore>();
    store.loadPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: const Text(
          'Parceiras',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) =>
            store.isAdmin
                ? IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _navigateToPartnerForm(),
            )
                : const SizedBox.shrink(),
          ),
        ],
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
              _buildPartnersList(),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  'Nossas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Parceiras',
                    style: TextStyle(
                      color: Color(0xFF8B6F9B),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnersList() {
    return Expanded(
      child: Observer(
        builder: (_) {
          if (!store.hasPartners) {
            return const Center(
              child: Text(
                'Nenhuma parceira encontrada',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: store.partners.length,
            itemBuilder: (context, index) {
              final partner = store.partners[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPartnerCard(partner),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPartnerCard(Partner partner) {
    return GestureDetector(
      onTap: () => _navigateToPartnerDetail(partner),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Logo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B6F9B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF8B6F9B).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: partner.logoUrl != null && partner.logoUrl!.isNotEmpty
                      ? Image.network(
                    partner.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildLogoPlaceholder(),
                  )
                      : _buildLogoPlaceholder(),
                ),
              ),
              const SizedBox(width: 16),
              // Conteúdo da parceira
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B6F9B),
                      ),
                    ),
                    if (partner.description != null &&
                        partner.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        partner.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: partner.isActive
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: store.isAdmin ? Text(
                            partner.isActive ? 'Ativa' : 'Inativa',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: partner.isActive ? Colors.green : Colors
                                  .red,
                            ),
                          ) : const Text(""),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Seta
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

  Widget _buildLogoPlaceholder() {
    return const Center(
      child: Icon(
        Icons.business,
        color: Color(0xFF8B6F9B),
        size: 32,
      ),
    );
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
          Text(
            store.errorMessage ?? 'Erro desconhecido',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              store.clearError();
              store.loadPartners();
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

  void _navigateToPartnerDetail(Partner partner) {
    store.setSelectedPartner(partner);
    Modular.to.pushNamed('/partners/detail');
  }

  void _navigateToPartnerForm() {
    Modular.to.pushNamed('/partners/form');
  }
}