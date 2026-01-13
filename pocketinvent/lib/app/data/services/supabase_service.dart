import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/telephone_model.dart';
import '../models/transaction_model.dart';

class SupabaseService extends GetxService {
  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;
  User? get currentUser => _client.auth.currentUser;
  String? get userId => currentUser?.id;

  // Auth methods
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<bool> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.pocketinvent://login-callback/',
    );
    return true;
  }

  Future<bool> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.pocketinvent://login-callback/',
    );
    return true;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Telephone CRUD
  Future<List<TelephoneModel>> getTelephones() async {
    final response = await _client.from('telephone').select('''
          *,
          marque:marque_id(nom),
          modele:modele_id(nom),
          couleur:couleur_id(libelle),
          capacite:capacite_id(valeur),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').eq('user_id', userId!).order('created_at', ascending: false);

    return (response as List)
        .map((json) => TelephoneModel.fromJson(json))
        .toList();
  }

  Future<TelephoneModel> getTelephone(String id) async {
    final response = await _client.from('telephone').select('''
          *,
          marque:marque_id(nom),
          modele:modele_id(nom),
          couleur:couleur_id(libelle),
          capacite:capacite_id(valeur),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').eq('id', id).eq('user_id', userId!).single();

    return TelephoneModel.fromJson(response);
  }

  Future<TelephoneModel?> getTelephoneByImei(String imei) async {
    final response = await _client.from('telephone').select('''
          *,
          marque:marque_id(nom),
          modele:modele_id(nom),
          couleur:couleur_id(libelle),
          capacite:capacite_id(valeur),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''').eq('imei', imei).eq('user_id', userId!).maybeSingle();

    return response != null ? TelephoneModel.fromJson(response) : null;
  }

  Future<String> createTelephone(Map<String, dynamic> data) async {
    data['user_id'] = userId;
    data['created_at'] = DateTime.now().toIso8601String();
    data['updated_at'] = DateTime.now().toIso8601String();

    final response =
        await _client.from('telephone').insert(data).select().single();

    return response['id'];
  }

  Future<void> updateTelephone(String id, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();

    await _client
        .from('telephone')
        .update(data)
        .eq('id', id)
        .eq('user_id', userId!);
  }

  Future<void> deleteTelephone(String id) async {
    await _client
        .from('telephone')
        .delete()
        .eq('id', id)
        .eq('user_id', userId!);
  }

  // Transaction CRUD
  Future<List<TransactionModel>> getTransactions(String telephoneId) async {
    final response = await _client
        .from('historique_transaction')
        .select('''
          *,
          client:client_id(nom),
          fournisseur:fournisseur_id(nom),
          statut_paiement:statut_paiement_id(libelle)
        ''')
        .eq('telephone_id', telephoneId)
        .eq('user_id', userId!)
        .order('date_transaction', ascending: false);

    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  Future<String> createTransaction(Map<String, dynamic> data) async {
    data['user_id'] = userId;

    final response = await _client
        .from('historique_transaction')
        .insert(data)
        .select()
        .single();

    return response['id'];
  }

  // Upload photo
  Future<String> uploadPhoto(String path, Uint8List bytes) async {
    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from('phone-photos').uploadBinary(fileName, bytes);

    return _client.storage.from('phone-photos').getPublicUrl(fileName);
  }

  // Reference data
  Future<List<Map<String, dynamic>>> getMarques() async {
    return await _client.from('marque').select().order('nom');
  }

  Future<List<Map<String, dynamic>>> getModeles(String marqueId) async {
    return await _client
        .from('modele')
        .select()
        .eq('marque_id', marqueId)
        .order('nom');
  }

  Future<List<Map<String, dynamic>>> getCouleurs() async {
    return await _client.from('couleur').select().order('libelle');
  }

  Future<List<Map<String, dynamic>>> getCapacites() async {
    return await _client.from('capacite').select().order('valeur');
  }

  Future<List<Map<String, dynamic>>> getFournisseurs() async {
    return await _client
        .from('fournisseur')
        .select()
        .eq('user_id', userId!)
        .order('nom');
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    return await _client
        .from('client')
        .select()
        .eq('user_id', userId!)
        .order('nom');
  }

  Future<List<Map<String, dynamic>>> getStatutsPaiement() async {
    return await _client.from('statut_paiement').select().order('libelle');
  }
}
