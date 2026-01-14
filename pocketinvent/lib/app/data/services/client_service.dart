import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/client.dart';

class ClientService extends GetxService {
  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  Future<List<Client>> getClients() async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('client')
          .select()
          .eq('user_id', _userId!)
          .order('nom');

      return (response as List).map((json) => Client.fromJson(json)).toList();
    } catch (e) {
      print('[ClientService] Error fetching clients: $e');
      rethrow;
    }
  }

  Future<Client> getClientById(String id) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('client')
          .select()
          .eq('id', id)
          .eq('user_id', _userId!)
          .single();

      return Client.fromJson(response);
    } catch (e) {
      print('[ClientService] Error fetching client: $e');
      rethrow;
    }
  }

  Future<Client> createClient({
    required String nom,
    String? telephone,
    String? email,
  }) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('client')
          .insert({
            'user_id': _userId,
            'nom': nom,
            'telephone': telephone,
            'email': email,
          })
          .select()
          .single();

      return Client.fromJson(response);
    } catch (e) {
      print('[ClientService] Error creating client: $e');
      rethrow;
    }
  }

  Future<void> updateClient({
    required String id,
    required String nom,
    String? telephone,
    String? email,
  }) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('client')
          .update({
            'nom': nom,
            'telephone': telephone,
            'email': email,
          })
          .eq('id', id)
          .eq('user_id', _userId!);
    } catch (e) {
      print('[ClientService] Error updating client: $e');
      rethrow;
    }
  }

  Future<void> deleteClient(String id) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('client')
          .delete()
          .eq('id', id)
          .eq('user_id', _userId!);
    } catch (e) {
      print('[ClientService] Error deleting client: $e');
      rethrow;
    }
  }

  Future<List<Client>> searchClients(String query) async {
    try {
      if (_userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('client')
          .select()
          .eq('user_id', _userId!)
          .ilike('nom', '%$query%')
          .order('nom');

      return (response as List).map((json) => Client.fromJson(json)).toList();
    } catch (e) {
      print('[ClientService] Error searching clients: $e');
      rethrow;
    }
  }
}
