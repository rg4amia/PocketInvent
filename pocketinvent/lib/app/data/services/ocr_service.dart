import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService extends GetxService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Store last OCR result for debugging
  String? lastRecognizedText;
  String? lastErrorMessage;

  Future<String?> extractImeiFromImage(String imagePath) async {
    try {
      lastRecognizedText = null;
      lastErrorMessage = null;

      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Store for debugging
      lastRecognizedText = recognizedText.text;

      if (recognizedText.text.isEmpty) {
        lastErrorMessage = 'Aucun texte détecté dans l\'image';
        return null;
      }

      print('[OCR] Texte reconnu: ${recognizedText.text}');

      // Extract IMEI (15 digits)
      final String text = recognizedText.text;

      // Try multiple patterns to find IMEI

      // Pattern 1: 15 consecutive digits
      final RegExp imeiPattern = RegExp(r'\b\d{15}\b');
      final Match? match = imeiPattern.firstMatch(text);

      if (match != null) {
        print('[OCR] IMEI trouvé (pattern 1): ${match.group(0)}');
        return match.group(0);
      }

      // Pattern 2: IMEI with spaces or dashes (common format: 35 987610 2345678 or 35-98-7610-2345-678)
      final RegExp imeiPatternWithSeparators = RegExp(
        r'\b\d{2}[\s-]?\d{2}[\s-]?\d{4,6}[\s-]?\d{4,6}[\s-]?\d{1,3}\b',
      );
      final matches = imeiPatternWithSeparators.allMatches(text);

      for (final match in matches) {
        final cleaned = match.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
        if (cleaned.length == 15) {
          print('[OCR] IMEI trouvé (pattern 2): $cleaned');
          return cleaned;
        }
      }

      // Pattern 3: Look for sequences of digits and try to extract 15 digits
      final allDigits = text.replaceAll(RegExp(r'[^\d]'), '');
      print('[OCR] Tous les chiffres extraits: $allDigits');

      if (allDigits.length >= 15) {
        // Try to find a valid 15-digit sequence
        for (int i = 0; i <= allDigits.length - 15; i++) {
          final candidate = allDigits.substring(i, i + 15);
          // Basic validation: IMEI usually starts with 35, 86, etc.
          if (candidate.startsWith(RegExp(r'[0-9]{2}'))) {
            print('[OCR] IMEI candidat trouvé (pattern 3): $candidate');
            return candidate;
          }
        }
      }

      lastErrorMessage =
          'IMEI non détecté. Texte reconnu: ${text.length > 50 ? text.substring(0, 50) + "..." : text}';
      return null;
    } catch (e) {
      print('[OCR] Erreur lors de l\'extraction: $e');
      lastErrorMessage = 'Erreur technique: ${e.toString()}';
      return null;
    }
  }

  String getDetailedErrorMessage() {
    if (lastErrorMessage != null) {
      return lastErrorMessage!;
    }
    if (lastRecognizedText != null && lastRecognizedText!.isNotEmpty) {
      return 'Texte détecté mais aucun IMEI valide trouvé.\n\nConseils:\n• Assurez-vous que l\'IMEI est bien visible\n• Évitez les reflets et ombres\n• Tenez le téléphone stable\n• Rapprochez-vous de l\'étiquette';
    }
    return 'Impossible de lire l\'image.\n\nConseils:\n• Améliorez l\'éclairage\n• Nettoyez l\'objectif de la caméra\n• Tenez le téléphone stable\n• Assurez-vous que l\'IMEI est net et lisible';
  }

  bool validateImei(String imei) {
    // IMEI must be exactly 15 digits
    if (imei.length != 15) return false;

    // Check if all characters are digits
    return RegExp(r'^\d{15}$').hasMatch(imei);
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }
}
