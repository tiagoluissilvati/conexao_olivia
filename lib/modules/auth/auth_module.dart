import 'package:conexaoolivia/modules/auth/pages/version_check_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'stores/auth_store.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/forgot_password_page.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<AuthStore>(AuthStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const VersionCheckPage());
    r.child('/login', child: (context) => const LoginPage());
    r.child('/register', child: (context) => const RegisterPage());
    r.child('/forgot-password', child: (context) => const ForgotPasswordPage());
  }
}