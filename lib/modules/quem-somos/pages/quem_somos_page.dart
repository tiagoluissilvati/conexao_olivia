import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'quem_somos_store.dart';

class QuemSomosPage extends StatefulWidget {
  @override
  _QuemSomosPageState createState() => _QuemSomosPageState();
}

class _QuemSomosPageState extends State<QuemSomosPage>
    with TickerProviderStateMixin {
  final QuemSomosStore store = Modular.get<QuemSomosStore>();

  @override
  void initState() {
    super.initState();

    // Inicializa as animações
    store.initAnimations(this);

    // Inicia todas as animações com delay de 500ms entre cada
    store.startAllAnimationsWithDelay();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Quem Somos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 50),
          child: Column(
            children: [
              _buildSection(
                title: 'Missão',
                content: 'Unir o empresariado feminino em prol de um único objetivo: fortalecer o relacionamento entre as empreendedoras e gerar novos negócios, aumentando o lucro e fazendo a roda da economia girar no ABC, assim surgiu o Grupo Olivia Empreendedoras, em outubro de 2023.',
                icon: Icons.flag,
                animation: store.missaoAnimation,
              ),
              SizedBox(height: 16),
              _buildSection(
                title: 'O Grupo',
                content: 'Conta com as diretoras: Cláudia de Freitas, Luana Bigatton Minotti, Daniela Bigatton e Cristina Rufini que, juntas, promovem eventos, cursos, palestras e rodada de negócios. Hoje já contamos com 420 empreendedoras no grupo.',
                icon: Icons.group,
                animation: store.grupoAnimation,
              ),
              SizedBox(height: 16),
              _buildSection(
                title: 'Ações',
                content: 'Além do lado empresarial, o grupo também atua em outros projetos, dentre eles o Olivia Ação Social. Atualmente a Ação Social busca ajudar mulheres que sofrem vulnerabilidade em situação de rua doando calcinha e absorventes.',
                icon: Icons.favorite,
                animation: store.acoesAnimation,
              ),
              SizedBox(height: 16),
              _buildSection(
                title: 'Palestras',
                content: 'As palestras são voltadas ao empreendedorismo feminino, impactando diretamente no crescimento das empresas, prestadoras de serviços e pequenos negócios! Teremos a presença de palestrantes renomadas e com trajetórias consolidadas.',
                icon: Icons.mic,
                animation: store.palestrasAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Animation<double> animation,
  }) {
    return Observer(
      builder: (_) => AnimatedBuilder(
        animation: animation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Usa a cor do theme
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
        builder: (context, child) {
          // Animação simples: desliza da direita para a esquerda
          final slideValue = (animation.value - 1.0) * 300; // Começa fora da tela

          return Transform.translate(
            offset: Offset(slideValue, 0),
            child: child,
          );
        },
      ),
    );
  }
}