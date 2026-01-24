// pages/agenda_page.dart
import 'package:conexaoolivia/core/theme/app_colors.dart';
import 'package:conexaoolivia/modules/eventos/pages/event_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../models/event_model.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late final EventStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get<EventStore>();
    store.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F9B),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        actions: [
          Observer(
            builder: (_) => store.isAdmin
                ? IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _navigateToEventForm(),
            )
                : const SizedBox.shrink()
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
              _buildEventsList(),
              _buildFooter(),
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

            // Título central
            Column(
              children: [
                const Text(
                  'Nossa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Agenda',
                    style: TextStyle(
                      color: Color(0xFF8B6F9B),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 Text(
                  'de ${DateTime.now().year}' ,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Expanded(
      child: Observer(
        builder: (_) {
          if (!store.hasEvents) {
            return const Center(
              child: Text(
                'Nenhum evento encontrado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: store.events.length,
            itemBuilder: (context, index) {
              final event = store.events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEventCard(event),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return GestureDetector(
      onTap: () => _navigateToEventDetail(event),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8B6F9B),
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
              // Data
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${event.eventDate.day}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B6F9B),
                      ),
                    ),
                    Text(
                      event.getMonthAbbreviation(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8B6F9B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Conteúdo do evento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.weekDay,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (event.formattedTime.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'às ${event.formattedTime}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (event.location != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.location!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Seta
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'As datas são para você já se organizar e reservar na agenda! Assim, podem se programar com tranquilidade!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
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
              store.loadEvents();
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

  void _navigateToEventDetail(Event event) {
    store.setSelectedEvent(event);
    Modular.to.pushNamed('/events/detail');
  }

  void _navigateToEventForm() {
    Modular.to.pushNamed('/events/form');
  }
}