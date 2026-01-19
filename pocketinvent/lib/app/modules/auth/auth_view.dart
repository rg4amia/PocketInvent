import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../core/theme/app_colors.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => Text(
                  controller.isLogin.value ? 'Connexion' : 'Inscription',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gérez votre stock de téléphones',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),

              Obx(
                () => controller.isLogin.value
                    ? _buildLoginForm()
                    : _buildSignUpForm(),
              ),

              const SizedBox(height: 24),

              // Divider with "Or"
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.separator)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Ou',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.separator)),
                ],
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
                Icons.g_mobiledata_rounded,
                controller.signInWithGoogle,
              ),

              const SizedBox(height: 32),

              // Toggle Login/SignUp
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.isLogin.value
                        ? 'Pas encore de compte ? '
                        : 'Déjà un compte ? ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.toggleAuthMode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      controller.isLogin.value ? 'S\'inscrire' : 'Se connecter',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
        _buildLabel('Email'),
        const SizedBox(height: 6),
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'votre@email.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Mot de passe'),
        const SizedBox(height: 6),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.showPassword.value,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
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
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Mot de passe oublié ?',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 13,
              ),
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
        _buildLabel('Email'),
        const SizedBox(height: 6),
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'votre@email.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Mot de passe'),
        const SizedBox(height: 6),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.showPassword.value,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.textPrimary, size: 24),
      label: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: AppColors.border, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
