import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/marque.dart';
import '../models/modele.dart';
import '../models/couleur.dart';
import '../models/capacite.dart';
import '../models/statut_paiement.dart';

class ReferenceService extends GetxService {
  final _supabase = Supabase.instance.client;

  // MARQUES
  Future<List<Marque>> getMarques() async {
    try {
      final response = await _supabase.from('marque').select().order('nom');

      return (response as List).map((json) => Marque.fromJson(json)).toList();
    } catch (e) {
      print('[ReferenceService] Error fetching marques: $e');
      rethrow;
    }
  }

  Future<Marque> createMarque(String nom) async {
    try {
      final response =
          await _supabase.from('marque').insert({'nom': nom}).select().single();

      return Marque.fromJson(response);
    } catch (e) {
      print('[ReferenceService] Error creating marque: $e');
      rethrow;
    }
  }

  Future<void> updateMarque(String id, String nom) async {
    try {
      await _supabase.from('marque').update({'nom': nom}).eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error updating marque: $e');
      rethrow;
    }
  }

  Future<void> deleteMarque(String id) async {
    try {
      await _supabase.from('marque').delete().eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error deleting marque: $e');
      rethrow;
    }
  }

  // MODELES
  Future<List<Modele>> getModeles({String? marqueId}) async {
    try {
      var query = _supabase.from('modele').select('*, marque!inner(nom)');

      if (marqueId != null) {
        query = query.eq('marque_id', marqueId);
      }

      final response = await query.order('nom');

      return (response as List).map((json) {
        return Modele.fromJson({
          ...json,
          'marque_nom': json['marque']['nom'],
        });
      }).toList();
    } catch (e) {
      print('[ReferenceService] Error fetching modeles: $e');
      rethrow;
    }
  }

  Future<Modele> createModele(String nom, String marqueId) async {
    try {
      final response = await _supabase
          .from('modele')
          .insert({
            'nom': nom,
            'marque_id': marqueId,
          })
          .select('*, marque!inner(nom)')
          .single();

      return Modele.fromJson({
        ...response,
        'marque_nom': response['marque']['nom'],
      });
    } catch (e) {
      print('[ReferenceService] Error creating modele: $e');
      rethrow;
    }
  }

  Future<void> updateModele(String id, String nom, String marqueId) async {
    try {
      await _supabase.from('modele').update({
        'nom': nom,
        'marque_id': marqueId,
      }).eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error updating modele: $e');
      rethrow;
    }
  }

  Future<void> deleteModele(String id) async {
    try {
      await _supabase.from('modele').delete().eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error deleting modele: $e');
      rethrow;
    }
  }

  // COULEURS
  Future<List<Couleur>> getCouleurs() async {
    try {
      final response =
          await _supabase.from('couleur').select().order('libelle');

      return (response as List).map((json) => Couleur.fromJson(json)).toList();
    } catch (e) {
      print('[ReferenceService] Error fetching couleurs: $e');
      rethrow;
    }
  }

  Future<Couleur> createCouleur(String libelle, String? codeCouleur) async {
    try {
      final response = await _supabase
          .from('couleur')
          .insert({
            'libelle': libelle,
            'code_couleur': codeCouleur,
          })
          .select()
          .single();

      return Couleur.fromJson(response);
    } catch (e) {
      print('[ReferenceService] Error creating couleur: $e');
      rethrow;
    }
  }

  Future<void> updateCouleur(
      String id, String libelle, String? codeCouleur) async {
    try {
      await _supabase.from('couleur').update({
        'libelle': libelle,
        'code_couleur': codeCouleur,
      }).eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error updating couleur: $e');
      rethrow;
    }
  }

  Future<void> deleteCouleur(String id) async {
    try {
      await _supabase.from('couleur').delete().eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error deleting couleur: $e');
      rethrow;
    }
  }

  // CAPACITES
  Future<List<Capacite>> getCapacites() async {
    try {
      final response =
          await _supabase.from('capacite').select().order('valeur');

      return (response as List).map((json) => Capacite.fromJson(json)).toList();
    } catch (e) {
      print('[ReferenceService] Error fetching capacites: $e');
      rethrow;
    }
  }

  Future<Capacite> createCapacite(String valeur) async {
    try {
      final response = await _supabase
          .from('capacite')
          .insert({'valeur': valeur})
          .select()
          .single();

      return Capacite.fromJson(response);
    } catch (e) {
      print('[ReferenceService] Error creating capacite: $e');
      rethrow;
    }
  }

  Future<void> updateCapacite(String id, String valeur) async {
    try {
      await _supabase.from('capacite').update({'valeur': valeur}).eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error updating capacite: $e');
      rethrow;
    }
  }

  Future<void> deleteCapacite(String id) async {
    try {
      await _supabase.from('capacite').delete().eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error deleting capacite: $e');
      rethrow;
    }
  }

  // STATUTS PAIEMENT
  Future<List<StatutPaiement>> getStatutsPaiement() async {
    try {
      final response =
          await _supabase.from('statut_paiement').select().order('libelle');

      return (response as List)
          .map((json) => StatutPaiement.fromJson(json))
          .toList();
    } catch (e) {
      print('[ReferenceService] Error fetching statuts: $e');
      rethrow;
    }
  }

  Future<StatutPaiement> createStatutPaiement(String libelle) async {
    try {
      final response = await _supabase
          .from('statut_paiement')
          .insert({'libelle': libelle})
          .select()
          .single();

      return StatutPaiement.fromJson(response);
    } catch (e) {
      print('[ReferenceService] Error creating statut: $e');
      rethrow;
    }
  }

  Future<void> updateStatutPaiement(String id, String libelle) async {
    try {
      await _supabase
          .from('statut_paiement')
          .update({'libelle': libelle}).eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error updating statut: $e');
      rethrow;
    }
  }

  Future<void> deleteStatutPaiement(String id) async {
    try {
      await _supabase.from('statut_paiement').delete().eq('id', id);
    } catch (e) {
      print('[ReferenceService] Error deleting statut: $e');
      rethrow;
    }
  }
}
