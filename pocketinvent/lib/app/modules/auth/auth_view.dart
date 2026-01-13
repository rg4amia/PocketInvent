import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/theme/app_colors.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Icon(Icons.phone_iphone, size: 80, color: AppColors.primaryBlue),
              const SizedBox(height: 16),
              Text(
                'PocketInvent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gérez votre stock de téléphones',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),

              Obx(
                () => controller.isLogin.value
                    ? _buildLoginForm()
                    : _buildSignUpForm(),
              ),

              const SizedBox(height: 24),

              // Social Login Buttons
              _buildSocialButton(
                'Continuer avec Apple',
                Icons.apple,
                controller.signInWithApple,
              ),
              const SizedBox(height: 12),
              _buildSocialButton(
                'Continuer avec Google',
                Icons.g_mobiledata,
                controller.signInWithGoogle,
              ),

              const SizedBox(height: 24),

              // Toggle Login/SignUp
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.isLogin.value
                        ? 'Pas encore de compte ? '
                        : 'Déjà un compte ? ',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: controller.toggleAuthMode,
                    child: Text(
                      controller.isLogin.value ? 'S\'inscrire' : 'Se connecter',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.showPassword.value,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.resetPassword,
            child: Text(
              'Mot de passe oublié ?',
              style: TextStyle(color: AppColors.primaryBlue),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.signIn,
            child: controller.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Se connecter'),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.showPassword.value,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.signUp,
            child: controller.isLoading.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('S\'inscrire'),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.textPrimary),
      label: Text(text, style: TextStyle(color: AppColors.textPrimary)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: AppColors.separator),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
