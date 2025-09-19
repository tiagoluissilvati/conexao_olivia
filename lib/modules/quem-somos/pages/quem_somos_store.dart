import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'quem_somos_store.g.dart';

class QuemSomosStore = QuemSomosStoreBase with _$QuemSomosStore;

abstract class QuemSomosStoreBase with Store {
  late AnimationController _missaoController;
  late AnimationController _grupoController;
  late AnimationController _acoesController;
  late AnimationController _palestrasController;

  late Animation<double> missaoAnimation;
  late Animation<double> grupoAnimation;
  late Animation<double> acoesAnimation;
  late Animation<double> palestrasAnimation;

  void initAnimations(TickerProvider vsync) {
    // Inicializa os controllers
    _missaoController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    );

    _grupoController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    );

    _acoesController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    );

    _palestrasController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: vsync,
    );

    // Cria as animações com curvas suaves
    missaoAnimation = CurvedAnimation(
      parent: _missaoController,
      curve: Curves.easeOutCubic,
    );

    grupoAnimation = CurvedAnimation(
      parent: _grupoController,
      curve: Curves.easeOutCubic,
    );

    acoesAnimation = CurvedAnimation(
      parent: _acoesController,
      curve: Curves.easeOutCubic,
    );

    palestrasAnimation = CurvedAnimation(
      parent: _palestrasController,
      curve: Curves.easeOutCubic,
    );
  }

  void startAllAnimationsWithDelay() {
    // Missão - inicia imediatamente
    Future.delayed(Duration(milliseconds: 0), () {
      _missaoController.forward();
    });

    // Grupo - 500ms de delay
    Future.delayed(Duration(milliseconds: 500), () {
      _grupoController.forward();
    });

    // Ações - 1000ms de delay
    Future.delayed(Duration(milliseconds: 1000), () {
      _acoesController.forward();
    });

    // Palestras - 1500ms de delay
    Future.delayed(Duration(milliseconds: 1500), () {
      _palestrasController.forward();
    });
  }

  void dispose() {
    _missaoController.dispose();
    _grupoController.dispose();
    _acoesController.dispose();
    _palestrasController.dispose();
  }

  // Método para resetar todas as animações (útil para testes)
  void resetAnimations() {
    _missaoController.reset();
    _grupoController.reset();
    _acoesController.reset();
    _palestrasController.reset();
  }
}