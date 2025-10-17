// modules/parceiras/pages/partner_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'partner_form_store.dart';
import 'partner_store.dart';

class PartnerDetailPage extends StatefulWidget {
  const PartnerDetailPage({Key? key}) : super(key: key);

  @override
  State<PartnerDetailPage> createState() => _PartnerDetailPageState();
}

class _PartnerDetailPageState extends State<PartnerDetailPage> {
  late final PartnerStore partnerStore;

  @override
  void initState() {
    super.initState();
    partnerStore = Modular.get<PartnerStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: const Text(
          'Detalhes da Parceira',
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
            builder: (_) => partnerStore.isAdmin
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: _editPartner,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: _confirmDeletePartner,
                ),
              ],
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          final partner = partnerStore.selectedPartner;

          if (partner == null) {
            return const Center(
              child: Text(
                'Parceira não encontrada',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (partnerStore.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B6F9B)),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(partner),
                const SizedBox(height: 30),
                _buildContent(partner),
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(partner) {
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
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: partner.logoUrl != null && partner.logoUrl!.isNotEmpty
                    ? Image.network(
                  partner.logoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildLogoPlaceholder(),
                )
                    : _buildLogoPlaceholder(),
              ),
            ),
            const SizedBox(height: 20),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: partner.isActive
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: partnerStore.isAdmin ?  Text(
                partner.isActive ? 'PARCEIRA ATIVA' : 'PARCEIRA INATIVA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: partner.isActive ? Colors.green : Colors.red,
                  letterSpacing: 0.5,
                ) ,
              ) : const Text(""),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return const Center(
      child: Icon(
        Icons.business,
        color: Color(0xFF8B6F9B),
        size: 48,
      ),
    );
  }

  Widget _buildContent(partner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome da parceira
          Container(
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
                  partner.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6F9B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF8B6F9B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cadastrada em ${partner.getFormattedCreatedDate()}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Descrição (se houver)
          if (partner.description != null && partner.description!.isNotEmpty) ...[
            Container(
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
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6F9B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    partner.description!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Endereço (se houver)
          if (partner.address != null && partner.address!.isNotEmpty) ...[
            Container(
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
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B6F9B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF8B6F9B),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          partner.address!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8B6F9B).withOpacity(0.3),
              const Color(0xFF8B6F9B),
              const Color(0xFF8B6F9B).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  void _editPartner() {
    final formStore = Modular.get<PartnerFormStore>();
    formStore.initializeWithPartner(partnerStore.selectedPartner!);
    Modular.to.pushNamed('/partners/form').then((_) {
      partnerStore.loadPartners();
    });
  }

  void _confirmDeletePartner() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta parceira?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePartner();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _deletePartner() async {
    final success = await partnerStore.deletePartner(partnerStore.selectedPartner!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parceira excluída com sucesso!'),
          backgroundColor: Color(0xFF8B6F9B),
        ),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(partnerStore.errorMessage ?? 'Erro ao excluir parceira'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}