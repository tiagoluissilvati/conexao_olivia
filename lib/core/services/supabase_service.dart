import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static late Supabase _instance;
  static SupabaseClient get client => _instance.client;

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    _instance = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  static User? get currentUser => client.auth.currentUser;

  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Database methods
  static PostgrestQueryBuilder from(String table) {
    return client.from(table);
  }

  // Storage methods
  static SupabaseStorageClient get storage => client.storage;
}