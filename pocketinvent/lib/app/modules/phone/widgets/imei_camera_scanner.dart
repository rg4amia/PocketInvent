import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:get/get.dart';

class ImeiCameraScanner extends StatefulWidget {
  final Function(String) onImeiDetected;

  const ImeiCameraScanner({
    Key? key,
    required this.onImeiDetected,
  }) : super(key: key);

  @override
  State<ImeiCameraScanner> createState() => _ImeiCameraScannerState();
}

class _ImeiCameraScannerState extends State<ImeiCameraScanner> {
  CameraController? _cameraController;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isDetecting = false;
  bool _isInitialized = false;
  String? _detectedText;
  String? _lastDetectedImei;
  Timer? _detectionTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showError('Aucune caméra disponible');
        return;
      }

      final camera = cameras.first;
      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      // Start continuous detection
      _startContinuousDetection();
    } catch (e) {
      _showError('Erreur d\'initialisation: $e');
    }
  }

  void _startContinuousDetection() {
    _detectionTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_isInitialized && !_isDetecting) {
        _detectImei();
      }
    });
  }

  Future<void> _detectImei() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isDetecting) return;

    setState(() {
      _isDetecting = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (!mounted) return;

      setState(() {
        _detectedText = recognizedText.text;
      });

      // Try to extract IMEI
      final imei = _extractImei(recognizedText.text);
      if (imei != null && imei != _lastDetectedImei) {
        _lastDetectedImei = imei;
        _onImeiFound(imei);
      }
    } catch (e) {
      print('[Scanner] Erreur de détection: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDetecting = false;
        });
      }
    }
  }

  String? _extractImei(String text) {
    // Pattern 1: 15 consecutive digits
    final RegExp imeiPattern = RegExp(r'\b\d{15}\b');
    final Match? match = imeiPattern.firstMatch(text);

    if (match != null) {
      return match.group(0);
    }

    // Pattern 2: IMEI with spaces or dashes
    final RegExp imeiPatternWithSeparators = RegExp(
      r'\b\d{2}[\s-]?\d{2}[\s-]?\d{4,6}[\s-]?\d{4,6}[\s-]?\d{1,3}\b',
    );
    final matches = imeiPatternWithSeparators.allMatches(text);

    for (final match in matches) {
      final cleaned = match.group(0)!.replaceAll(RegExp(r'[\s-]'), '');
      if (cleaned.length == 15) {
        return cleaned;
      }
    }

    // Pattern 3: Extract from all digits
    final allDigits = text.replaceAll(RegExp(r'[^\d]'), '');
    if (allDigits.length >= 15) {
      for (int i = 0; i <= allDigits.length - 15; i++) {
        final candidate = allDigits.substring(i, i + 15);
        if (candidate.startsWith(RegExp(r'[0-9]{2}'))) {
          return candidate;
        }
      }
    }

    return null;
  }

  void _onImeiFound(String imei) {
    // Vibrate or play sound
    _detectionTimer?.cancel();

    // Show success feedback
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('IMEI détecté!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              imei,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 16),
            Text('Voulez-vous utiliser cet IMEI?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _lastDetectedImei = null;
              _startContinuousDetection();
            },
            child: Text('Réessayer'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back();
              widget.onImeiDetected(imei);
            },
            child: Text('Utiliser'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initialisation de la caméra...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),

          // Overlay with scanning frame
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Scanner l\'IMEI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isDetecting)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Analyse en cours...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    else
                      Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 32,
                      ),
                    SizedBox(height: 12),
                    Text(
                      'Placez l\'IMEI dans le cadre',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'La détection est automatique',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_detectedText != null && _detectedText!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Texte détecté: ${_detectedText!.length > 30 ? _detectedText!.substring(0, 30) + "..." : _detectedText}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Flash toggle button
          Positioned(
            top: 80,
            right: 16,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                onPressed: _toggleFlash,
                child: Icon(
                  _cameraController?.value.flashMode == FlashMode.torch
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() async {
    if (_cameraController == null) return;

    try {
      final currentMode = _cameraController!.value.flashMode;
      await _cameraController!.setFlashMode(
        currentMode == FlashMode.torch ? FlashMode.off : FlashMode.torch,
      );
      setState(() {});
    } catch (e) {
      print('Erreur flash: $e');
    }
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final scanAreaWidth = size.width * 0.8;
    final scanAreaHeight = size.height * 0.3;
    final left = (size.width - scanAreaWidth) / 2;
    final top = (size.height - scanAreaHeight) / 2;

    // Draw overlay with transparent scanning area
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight),
          Radius.circular(16),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw corner brackets
    final bracketPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final bracketLength = 30.0;

    // Top-left
    canvas.drawLine(
      Offset(left, top + bracketLength),
      Offset(left, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + bracketLength, top),
      bracketPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(left + scanAreaWidth - bracketLength, top),
      Offset(left + scanAreaWidth, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top),
      Offset(left + scanAreaWidth, top + bracketLength),
      bracketPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(left, top + scanAreaHeight - bracketLength),
      Offset(left, top + scanAreaHeight),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaHeight),
      Offset(left + bracketLength, top + scanAreaHeight),
      bracketPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(left + scanAreaWidth - bracketLength, top + scanAreaHeight),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top + scanAreaHeight - bracketLength),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      bracketPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
