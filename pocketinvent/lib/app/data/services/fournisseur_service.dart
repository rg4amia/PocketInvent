import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fournisseur.dart';

class FournisseurService extends GetxService {
  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  Future<List<Fournisseur>> getFournisseurs() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('fournisseur')
          .select()
          .eq('user_id', _userId!)
          .order('nom');

      return (response as List)
          .map((json) => Fournisseur.fromJson(json))
          .toList();
    } catch (e) {
      print('[FournisseurService] Error fetching fournisseurs: $e');
      rethrow;
    }
  }

  Future<Fournisseur> getFournisseurById(String id) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('fournisseur')
          .select()
          .eq('id', id)
          .eq('user_id', _userId!)
          .single();

      return Fournisseur.fromJson(response);
    } catch (e) {
      print('[FournisseurService] Error fetching fournisseur: $e');
      rethrow;
    }
  }

  Future<Fournisseur> createFournisseur({
    required String nom,
    String? telephone,
    String? email,
    String? photoIdentiteUrl,
  }) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('fournisseur')
          .insert({
            'user_id': _userId,
            'nom': nom,
            'telephone': telephone,
            'email': email,
            'photo_identite_url': photoIdentiteUrl,
          })
          .select()
          .single();

      return Fournisseur.fromJson(response);
    } catch (e) {
      print('[FournisseurService] Error creating fournisseur: $e');
      rethrow;
    }
  }

  Future<void> updateFournisseur({
    required String id,
    required String nom,
    String? telephone,
    String? email,
    String? photoIdentiteUrl,
  }) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('fournisseur')
          .update({
            'nom': nom,
            'telephone': telephone,
            'email': email,
            'photo_identite_url': photoIdentiteUrl,
          })
          .eq('id', id)
          .eq('user_id', _userId!);
    } catch (e) {
      print('[FournisseurService] Error updating fournisseur: $e');
      rethrow;
    }
  }

  Future<void> deleteFournisseur(String id) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('fournisseur')
          .delete()
          .eq('id', id)
          .eq('user_id', _userId!);
    } catch (e) {
      print('[FournisseurService] Error deleting fournisseur: $e');
      rethrow;
    }
  }

  Future<List<Fournisseur>> searchFournisseurs(String query) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('fournisseur')
          .select()
          .eq('user_id', _userId!)
          .ilike('nom', '%$query%')
          .order('nom');

      return (response as List)
          .map((json) => Fournisseur.fromJson(json))
          .toList();
    } catch (e) {
      print('[FournisseurService] Error searching fournisseurs: $e');
      rethrow;
    }
  }

  Future<String> uploadIdPhoto(File file) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final fileName =
          '${_userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '$_userId/$fileName';

      await _supabase.storage.from('id-photos').upload(path, file);

      final url = _supabase.storage.from('id-photos').getPublicUrl(path);
      return url;
    } catch (e) {
      print('[FournisseurService] Error uploading ID photo: $e');
      rethrow;
    }
  }

  Future<void> deleteIdPhoto(String url) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final path = url.split('/id-photos/').last;
      await _supabase.storage.from('id-photos').remove([path]);
    } catch (e) {
      print('[FournisseurService] Error deleting ID photo: $e');
      rethrow;
    }
  }
}
