// pages/event_form_page.dart
import 'dart:io';
import 'package:conexaoolivia/modules/eventos/pages/event_form_store.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_store.dart';
import 'package:conexaoolivia/modules/galeria-eventos/models/image_upload_model.dart';
import 'package:conexaoolivia/modules/widgets/custom_text_field.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({Key? key}) : super(key: key);

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _imagePicker = ImagePicker();

  late final EventStore eventStore;
  late final EventFormStore formStore;

  @override
  void initState() {
    super.initState();
    eventStore = Modular.get<EventStore>();
    formStore = Modular.get<EventFormStore>();
    _setupControllers();
  }

  void _setupControllers() {
    _titleController.text = formStore.title;
    _descriptionController.text = formStore.description;
    _timeController.text = _formatTimeForInput(formStore.eventTime);
    _locationController.text = formStore.location;
    _linkController.text = formStore.link;

    _titleController.addListener(() => formStore.setTitle(_titleController.text));
    _descriptionController.addListener(() => formStore.setDescription(_descriptionController.text));
    _timeController.addListener(() => formStore.setEventTime(_timeController.text));
    _locationController.addListener(() => formStore.setLocation(_locationController.text));
    _linkController.addListener(() => formStore.setLink(_linkController.text));
  }

  String _formatTimeForInput(String timeString) {
    if (timeString.isEmpty) return '';
    if (timeString.contains(':')) {
      List<String> parts = timeString.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    }
    return timeString;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _linkController.dispose();
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
            formStore.isEditing ? 'Editar Evento' : 'Novo Evento',
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
                  formStore.isEditing ? Icons.edit_calendar : Icons.add_circle_outline,
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
            // Título
            _buildFormCard(
              title: 'Título do Evento',
              child: CustomTextField(
                controller: _titleController,
                label: '',
                hint: 'Digite o título do evento',
                textCapitalization: TextCapitalization.words,
                validator: formStore.validateTitle,
              ),
            ),
            const SizedBox(height: 16),

            // Data
            _buildFormCard(
              title: 'Data do Evento',
              child: Observer(
                builder: (_) => GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Color(0xFF8B6F9B), size: 20),
                        const SizedBox(width: 12),
                        Text(
                          '${formStore.selectedDate.day.toString().padLeft(2, '0')}/${formStore.selectedDate.month.toString().padLeft(2, '0')}/${formStore.selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Horário
            _buildFormCard(
              title: 'Horário (Opcional)',
              child: CustomTextField(
                controller: _timeController,
                label: '',
                hint: 'Ex: 19:00',
                keyboardType: TextInputType.text,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9:]'))],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):([0-5][0-9])$');
                  if (!timeRegex.hasMatch(value.trim())) {
                    return 'Use formato HH:MM (ex: 19:00)';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // Local
            _buildFormCard(
              title: 'Local (Opcional)',
              child: CustomTextField(
                controller: _locationController,
                label: '',
                hint: 'Local e valor a negociar',
              ),
            ),
            const SizedBox(height: 16),

            // Descrição
            _buildFormCard(
              title: 'Descrição (Opcional)',
              child: CustomTextField(
                controller: _descriptionController,
                label: '',
                hint: 'Digite uma descrição detalhada do evento',
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 16),

            // Link
            _buildFormCard(
              title: 'Link',
              child: CustomTextField(
                controller: _linkController,
                label: '',
                hint: 'Informe o link para compra do ingresso',
              ),
            ),
            const SizedBox(height: 16),

            // NOVO: Evento em Destaque
            /*
            _buildFormCard(
              title: 'Configurações',
              child: Observer(
                builder: (_) => CheckboxListTile(
                  title: const Text('Marcar como Evento em Destaque'),
                  subtitle: const Text('Apenas um evento pode estar em destaque por vez'),
                  value: formStore.isFeatured,
                  onChanged: (value) => formStore.setIsFeatured(value ?? false),
                  activeColor: const Color(0xFF8B6F9B),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),*/
            const SizedBox(height: 16),

            // NOVO: Banner Carrossel
            _buildBannerCard(
              title: 'Banner Carrossel (Opcional)',
              subtitle: 'Imagem horizontal para exibição em carrossel',
              bannerType: BannerType.carousel,
            ),
            const SizedBox(height: 16),

            // NOVO: Banner Grande
            _buildBannerCard(
              title: 'Banner Grande (Opcional)',
              subtitle: 'Imagem para destaque na página principal',
              bannerType: BannerType.large,
            ),
            const SizedBox(height: 30),

            // Botão salvar
            Observer(
              builder: (_) => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: formStore.isLoading ? null : _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B6F9B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: formStore.isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                    formStore.isEditing ? 'Atualizar Evento' : 'Criar Evento',
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

  // NOVO: Widget para upload de banners
  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required BannerType bannerType,
  }) {
    return Observer(
      builder: (_) {
        final hasBanner = bannerType == BannerType.carousel
            ? formStore.hasBannerCarousel
            : formStore.hasBannerLarge;

        final newImage = bannerType == BannerType.carousel
            ? formStore.bannerCarousel
            : formStore.bannerLarge;

        final existingUrl = bannerType == BannerType.carousel
            ? formStore.existingBannerCarouselUrl
            : formStore.existingBannerLargeUrl;

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
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8B6F9B))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 16),

              if (hasBanner) ...[
                _buildBannerPreview(newImage, existingUrl, bannerType),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickBannerImage(bannerType),
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
                        onPressed: () => _removeBanner(bannerType),
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
                  onPressed: () => _pickBannerImage(bannerType),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Adicionar Imagem'),
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

  Widget _buildBannerPreview(ImageUpload? newImage, String? existingUrl, BannerType bannerType) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B6F9B).withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: newImage != null
            ? (kIsWeb
            ? Image.network(newImage.localPath, fit: BoxFit.cover)
            : Image.file(File(newImage.localPath), fit: BoxFit.cover))
            : (existingUrl != null && existingUrl.isNotEmpty
            ? Image.network(existingUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
            : _buildPlaceholder()),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
    );
  }

  Future<void> _pickBannerImage(BannerType bannerType) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
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

        if (bannerType == BannerType.carousel) {
          formStore.setBannerCarousel(imageUpload);
        } else {
          formStore.setBannerLarge(imageUpload);
        }
      }
    } catch (e) {
      formStore.setError('Erro ao selecionar imagem: ${e.toString()}');
    }
  }

  void _removeBanner(BannerType bannerType) {
    if (bannerType == BannerType.carousel) {
      formStore.removeBannerCarousel();
    } else {
      formStore.removeBannerLarge();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: formStore.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B6F9B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != formStore.selectedDate) {
      formStore.setSelectedDate(picked);
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formStore.isFormValid) {
      formStore.setError('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    formStore.setLoading(true);

    try {
      final event = formStore.buildEvent();
      bool success;

      if (formStore.isEditing) {
        success = await eventStore.updateEvent(
          event,
          bannerCarousel: formStore.bannerCarousel,
          bannerLarge: formStore.bannerLarge,
        );
      } else {
        success = await eventStore.createEvent(
          event,
          bannerCarousel: formStore.bannerCarousel,
          bannerLarge: formStore.bannerLarge,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(formStore.isEditing
                ? 'Evento atualizado com sucesso!'
                : 'Evento criado com sucesso!'),
            backgroundColor: const Color(0xFF8B6F9B),
          ),
        );
        Modular.to.pop();
      } else {
        formStore.setError(eventStore.errorMessage ?? 'Erro ao salvar evento');
      }
    } catch (e) {
      formStore.setError('Erro inesperado: $e');
    } finally {
      formStore.setLoading(false);
    }
  }

  void _handleBackPress() {
    if (formStore.hasPendingChanges ||
        formStore.title.isNotEmpty ||
        formStore.description.isNotEmpty) {
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

enum BannerType { carousel, large }