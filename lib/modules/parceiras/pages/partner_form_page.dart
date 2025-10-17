// modules/parceiras/pages/partner_form_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../galeria-eventos/models/image_upload_model.dart';
import '../../widgets/custom_text_field.dart';
import 'partner_form_store.dart';
import 'partner_store.dart';

class PartnerFormPage extends StatefulWidget {
  const PartnerFormPage({Key? key}) : super(key: key);

  @override
  State<PartnerFormPage> createState() => _PartnerFormPageState();
}

class _PartnerFormPageState extends State<PartnerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _imagePicker = ImagePicker();

  late final PartnerStore partnerStore;
  late final PartnerFormStore formStore;

  @override
  void initState() {
    super.initState();
    partnerStore = Modular.get<PartnerStore>();
    formStore = Modular.get<PartnerFormStore>();
    _setupControllers();
  }

  void _setupControllers() {
    _nameController.text = formStore.name;
    _descriptionController.text = formStore.description;
    _addressController.text = formStore.address;

    _nameController.addListener(() => formStore.setName(_nameController.text));
    _descriptionController.addListener(() => formStore.setDescription(_descriptionController.text));
    _addressController.addListener(() => formStore.setAddress(_addressController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    formStore.clearForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: Observer(
          builder: (_) => Text(
            formStore.isEditing ? 'Editar Parceira' : 'Nova Parceira',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _handleBackPress(),
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
              child: Observer(
                builder: (_) => Icon(
                  formStore.isEditing ? Icons.edit : Icons.business_center,
                  color: Colors.white,
                  size: 40,
                ),
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
              title: 'Nome da Parceira',
              child: CustomTextField(
                controller: _nameController,
                label: '',
                hint: 'Digite o nome da parceira',
                textCapitalization: TextCapitalization.words,
                validator: formStore.validateName,
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            _buildFormCard(
              title: 'Descrição (Opcional)',
              child: CustomTextField(
                controller: _descriptionController,
                label: '',
                hint: 'Descreva a parceira e seus serviços',
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 16),

            // Endereço
            _buildFormCard(
              title: 'Endereço (Opcional)',
              child: CustomTextField(
                controller: _addressController,
                label: '',
                hint: 'Digite o endereço completo',
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Status Ativo
            _buildFormCard(
              title: 'Status',
              child: Observer(
                builder: (_) => CheckboxListTile(
                  title: const Text('Parceira Ativa'),
                  subtitle: const Text('Parceiras inativas não são exibidas para usuários comuns'),
                  value: formStore.isActive,
                  onChanged: (value) => formStore.setIsActive(value ?? true),
                  activeColor: const Color(0xFF8B6F9B),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logo
            _buildLogoCard(),
            const SizedBox(height: 16),

            // Data de cadastro (apenas ao editar)
            if (formStore.isEditing && formStore.editingPartner != null) ...[
              _buildFormCard(
                title: 'Data de Cadastro',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF8B6F9B), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        formStore.editingPartner!.getFormattedCreatedDate(),
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
                  onPressed: formStore.isLoading ? null : _savePartner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6F9B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: formStore.isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                    formStore.isEditing ? 'Atualizar Parceira' : 'Criar Parceira',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

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
                    Expanded(child: Text(formStore.errorMessage!, style: TextStyle(color: Colors.red.shade700))),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8B6F9B)),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildLogoCard() {
    return Observer(
      builder: (_) {
        final hasLogo = formStore.hasLogo;
        final newLogo = formStore.logo;
        final existingUrl = formStore.existingLogoUrl;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B6F9B).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Logo (Opcional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8B6F9B))),
              const SizedBox(height: 4),
              Text('Imagem que representa a parceira', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 16),

              if (hasLogo) ...[
                _buildLogoPreview(newLogo, existingUrl),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickLogoImage,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Alterar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8B6F9B),
                          side: const BorderSide(color: Color(0xFF8B6F9B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => formStore.removeLogo(),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Remover'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _pickLogoImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Adicionar Logo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6F9B).withOpacity(0.1),
                    foregroundColor: const Color(0xFF8B6F9B),
                    elevation: 0,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoPreview(ImageUpload? newLogo, String? existingUrl) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B6F9B).withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: newLogo != null
            ? (kIsWeb
            ? Image.network(newLogo.localPath, fit: BoxFit.contain)
            : Image.file(File(newLogo.localPath), fit: BoxFit.contain))
            : (existingUrl != null && existingUrl.isNotEmpty
            ? Image.network(existingUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => _buildPlaceholder())
            : _buildPlaceholder()),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.business, color: Colors.grey, size: 40)),
    );
  }

  Future<void> _pickLogoImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        int fileSize = 0;
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          fileSize = bytes.length;
        } else {
          final file = File(image.path);
          final fileStats = await file.stat();
          fileSize = fileStats.size;
        }

        final mimeType = lookupMimeType(image.path) ?? lookupMimeType(image.name) ?? 'image/jpeg';

        final imageUpload = ImageUpload(
          localPath: image.path,
          fileName: image.name,
          mimeType: mimeType,
          fileSize: fileSize,
        );

        formStore.setLogo(imageUpload);
      }
    } catch (e) {
      formStore.setError('Erro ao selecionar imagem: ${e.toString()}');
    }
  }

  Future<void> _savePartner() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formStore.isFormValid) {
      formStore.setError('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    formStore.setLoading(true);

    try {
      final partner = formStore.buildPartner();
      bool success;

      if (formStore.isEditing) {
        success = await partnerStore.updatePartner(partner, logo: formStore.logo);
      } else {
        success = await partnerStore.createPartner(partner, logo: formStore.logo);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(formStore.isEditing ? 'Parceira atualizada com sucesso!' : 'Parceira criada com sucesso!'),
            backgroundColor: const Color(0xFF8B6F9B),
          ),
        );
        Modular.to.pop();
      } else {
        formStore.setError(partnerStore.errorMessage ?? 'Erro ao salvar parceira');
      }
    } catch (e) {
      formStore.setError('Erro inesperado: $e');
    } finally {
      formStore.setLoading(false);
    }
  }

  void _handleBackPress() {
    if (formStore.hasPendingChanges || formStore.name.isNotEmpty || formStore.description.isNotEmpty) {
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
}