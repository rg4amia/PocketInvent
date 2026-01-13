import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService extends GetxService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String?> extractImeiFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      // Extract IMEI (15 digits)
      final String text = recognizedText.text;

      // Pattern to match 15 consecutive digits
      final RegExp imeiPattern = RegExp(r'\b\d{15}\b');
      final Match? match = imeiPattern.firstMatch(text);

      if (match != null) {
        return match.group(0);
      }

      // Try to find IMEI with spaces or dashes
      final RegExp imeiPatternWithSeparators = RegExp(
        r'\b\d{2}[\s-]?\d{6}[\s-]?\d{6}[\s-]?\d{1}\b',
      );
      final Match? matchWithSeparators = imeiPatternWithSeparators.firstMatch(
        text,
      );

      if (matchWithSeparators != null) {
        // Remove spaces and dashes
        return matchWithSeparators.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
      }

      return null;
    } catch (e) {
      print('Error extracting IMEI: $e');
      return null;
    }
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
