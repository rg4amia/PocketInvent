import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLogin = true.obs;
  final isLoading = false.obs;
  final showPassword = false.obs;

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    emailController.clear();
    passwordController.clear();
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> signIn() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      await _supabaseService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la connexion: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      await _supabaseService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text,
      );
      Get.snackbar(
        'Succès',
        'Compte créé ! Vérifiez votre email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      isLogin.value = true;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'inscription: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      await _supabaseService.signInWithApple();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la connexion avec Apple: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _supabaseService.signInWithGoogle();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la connexion avec Google: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez entrer votre email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _supabaseService.resetPassword(emailController.text.trim());
      Get.snackbar(
        'Succès',
        'Email de réinitialisation envoyé',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'envoi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Veuillez entrer votre email');
      return false;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez entrer votre mot de passe');
      return false;
    }
    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Erreur',
        'Le mot de passe doit contenir au moins 6 caractères',
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
