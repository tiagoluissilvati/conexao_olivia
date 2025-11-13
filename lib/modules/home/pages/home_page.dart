import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/stores/auth_store.dart';
import '../../eventos/pages/event_store.dart';
import '../../eventos/models/event_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final EventStore eventStore;
  final PageController _carouselController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    eventStore = Modular.get<EventStore>();
    eventStore.loadEvents();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_carouselController.hasClients) {
        final upcomingEvents = _getUpcomingEvents();
        if (upcomingEvents.isEmpty) return;

        _currentPage = (_currentPage + 1) % upcomingEvents.length;

        _carouselController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authStore = Modular.get<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),
        centerTitle: true,
        title: const Text(""),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.primary,
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context, authStore);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: AppColors.error),
                  title: Text('Sair', style: TextStyle(color: AppColors.error)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    // Logo e Welcome Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // Logo
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/conexao_olivia.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.people_alt_rounded,
                                      color: AppColors.white,
                                      size: 35,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Welcome Card
                          Expanded(
                            child: Card(
                              elevation: 6,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.primary,
                                ),
                                child: Observer(
                                  builder: (_) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bem-vinda,',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                          color: AppColors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        authStore.currentUser?.name ?? 'Usuário',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    // NOVO: Banner do Evento em Destaque
                    Observer(
                      builder: (_) {
                        if (eventStore.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          );
                        }

                        final featuredEvent = eventStore.featuredEvent;
                        if (featuredEvent != null &&
                            featuredEvent.bannerLargeUrl != null &&
                            featuredEvent.bannerLargeUrl!.isNotEmpty) {
                          return _buildFeaturedEventBanner(featuredEvent);
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 10),

                    // NOVO: Carrossel de Próximos Eventos
                    Observer(
                      builder: (_) {
                        final upcomingEvents = _getUpcomingEvents();
                        if (upcomingEvents.isNotEmpty) {
                          return _buildEventsCarousel(upcomingEvents);
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 32),

                    // Cards de Ação
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildActionCard(
                            context,
                            backgroundImage: 'assets/images/calendario.png',
                            title: 'Eventos',
                            subtitle: 'Próximos eventos',
                            onTap: () {
                              Modular.to.pushNamed('/events/');
                            },
                          ),
                          _buildActionCard(
                            context,
                            backgroundImage: 'assets/images/quem_somos.png',
                            title: 'Quem Somos',
                            subtitle: 'Conheça nossa história',
                            onTap: () {
                              Modular.to.pushNamed('/quem-somos');
                            },
                          ),
                          _buildActionCard(
                            context,
                            backgroundImage: 'assets/images/galeria.png',
                            title: 'Galeria',
                            subtitle: 'Registros de nossos encontros',
                            onTap: () {
                              Modular.to.pushNamed('/gallery');
                            },
                          ),
                          _buildActionCard(
                            context,
                            backgroundImage: 'assets/images/parceiras.png',
                            title: 'Parceiras',
                            subtitle: 'Conheça as nossas parceiras de sucucesso',
                            onTap: () {
                              Modular.to.pushNamed('/partners');
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NOVO: Widget do Banner em Destaque
  Widget _buildFeaturedEventBanner(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Evento em Destaque',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _openImageViewer(
              context,
              event.bannerLargeUrl!,
              event.title,
            ),
            child: Hero(
              tag: 'featured_${event.id}',
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        event.bannerLargeUrl!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                          ),
                        ),
                      ),
                    ),
                    // Overlay com informações
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  '${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                if (event.eventTime != null) ...[
                                  const SizedBox(width: 12),
                                  const Icon(Icons.access_time, color: Colors.white70, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    event.formattedTime,
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Ícone de zoom
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NOVO: Carrossel de Eventos
  Widget _buildEventsCarousel(List<Event> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Próximos Eventos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () => Modular.to.pushNamed('/events/'),
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _carouselController,
            padEnds: false,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 24 : 8,
                  right: index == events.length - 1 ? 24 : 8,
                ),
                child: _buildCarouselItem(event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(Event event) {
    final hasBanner = event.bannerCarouselUrl != null &&
        event.bannerCarouselUrl!.isNotEmpty;
    final imageUrl = hasBanner
        ? event.bannerCarouselUrl!
        : (event.bannerLargeUrl ?? '');

    return GestureDetector(
      onTap: () {
        if (event.bannerLargeUrl != null && event.bannerLargeUrl!.isNotEmpty) {
          _openImageViewer(context, event.bannerLargeUrl!, event.title);
        }
      },
      child: Hero(
        tag: 'carousel_${event.id}',
        child: Container(
          width: double.infinity, // ocupa toda a largura disponível
          margin: const EdgeInsets.symmetric(horizontal: 8), // espaçamento entre itens do carousel
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  width: double.infinity, // largura total
                  height: 160,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      _buildCarouselPlaceholder(event),
                )
                    : _buildCarouselPlaceholder(event),
              ),
              // Overlay com título
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${event.eventDate.day}/${event.eventDate.month}',
                        style:
                        const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselPlaceholder(Event event) {
    return Container(
      width: 280,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event, color: AppColors.primary, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              event.title,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Obter próximos eventos (excluindo o em destaque)
  List<Event> _getUpcomingEvents() {
    final now = DateTime.now();
    final allEvents = eventStore.events
        .where((e) => e.eventDate.isAfter(now) ||
        e.eventDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day)))
        .toList();

    // Remover evento em destaque
    final featuredEvent = eventStore.featuredEvent;
    if (featuredEvent != null) {
      allEvents.removeWhere((e) => e.id == featuredEvent.id);
    }

    // Ordenar por data e pegar os próximos 4
    allEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return allEvents.take(4).toList();
  }

  // Visualizador de imagem com zoom
  void _openImageViewer(BuildContext context, String imageUrl, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          body: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                color: AppColors.primary,
              ),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.white, size: 48),
                  SizedBox(height: 16),
                  Text('Erro ao carregar imagem', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String backgroundImage,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary, // Fundo principal
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 🔹 Imagem central reduzida
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6, // controla tamanho da imagem
                  heightFactor: 0.6,
                  child: Image.asset(
                    backgroundImage,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              // 🔹 Título na parte superior
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    children: [
                      // Contorno do texto
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black,
                        ),
                      ),
                      // Texto preenchido
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 Subtítulo na parte inferior, um pouco mais abaixo
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context, AuthStore authStore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authStore.signOut();
              Modular.to.pushReplacementNamed('/auth/login');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}