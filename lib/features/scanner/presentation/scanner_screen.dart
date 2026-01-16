import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/hybrid_fish_service.dart';
import '../../../core/config/api_config.dart';
import '../../history/data/scan_history_model.dart';
import '../../history/data/history_repository.dart';
import 'result_screen.dart';
import 'widgets/bio_sonar_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final HybridFishService _fishService = HybridFishService();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  String? _errorMessage;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _errorMessage = null;
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    if (!ApiConfig.isConfigured) {
      setState(() {
        _errorMessage =
            'Please add your Gemini API key in:\nlib/core/config/api_config.dart';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    final result = await _fishService.identifyFish(_selectedImage!);

    // Save to History (Real Persistence)
    if (result.isIdentified) {
      try {
        final historyRepo = HistoryRepository();
        await historyRepo.saveScan(ScanRecord(
          fishLocalName: result.localNameBangla,
          fishScientificName: result.scientificName,
          confidence: result.confidence,
          imagePath: _selectedImage!.path,
          timestamp: DateTime.now(),
        ));
      } catch (e) {
        debugPrint('Failed to save history: $e');
      }
    }

    setState(() {
      _isAnalyzing = false;
    });

    if (!result.isIdentified) {
      setState(() {
        _errorMessage = result.errorMessage ?? 'Could not identify fish';
      });
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: _selectedImage!.path,
            fishNameLocal: result.displayName,
            fishNameScientific: result.scientificName,
            habitat: result.habitat,
            confidence: result.confidence,
            identificationMarkers: result.identificationMarkers,
            description: result.description,
            calories: result.calories,
            protein: result.protein,
            marketPrice: result.marketPrice,
            cookingMethod: result.cookingMethod,
            freshnessChecklist: result.freshnessChecklist,
            recipes: result.recipes,
            confusionBreaker:
                result.similarFishName != null && result.whyNotSimilar != null
                    ? ConfusionBreakerData(
                        confusedWith: result.similarFishName!,
                        explanation: result.whyNotSimilar!,
                      )
                    : null,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(76),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan Fish',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
        child: SafeArea(
          child: _selectedImage == null
              ? _buildImagePickerUI()
              : _buildImagePreviewUI(),
        ),
      ),
    );
  }

  Widget _buildImagePickerUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryMedium.withAlpha(76),
                    AppColors.primaryLight.withAlpha(25),
                  ],
                ),
                border: Border.all(color: AppColors.primaryLight, width: 3),
              ),
              child: const Icon(
                Icons.set_meal_outlined,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Capture or Select a Fish Image',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our AI will identify the species',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: _pickImageFromCamera,
              ),
              const SizedBox(width: 24),
              _buildOptionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: _pickImageFromGallery,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviewUI() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image Container
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: kIsWeb
                      ? Image.network(
                          _selectedImage!.path,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              // Error Overlay
              if (_errorMessage != null)
                Positioned(
                  top: 20,
                  left: 40,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentCoral.withAlpha(230),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

              // Bio-Sonar Animation Overlay
              if (_isAnalyzing)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: BioSonarScanner(
                      isScanning: _isAnalyzing,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

              // Analysis Text Overlay
              if (_isAnalyzing)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(150),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.primaryLight.withAlpha(100)),
                      ),
                      child: const Text(
                        'ANALYSIS IN PROGRESS...',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Control Bar
        Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!_isAnalyzing) ...[
                _buildControlButton(
                  icon: Icons.refresh,
                  label: 'Retake',
                  onTap: () => setState(() {
                    _selectedImage = null;
                    _errorMessage = null;
                  }),
                ),
                _buildControlButton(
                  icon: Icons.search,
                  label: 'Identify',
                  onTap: _analyzeImage,
                  isPrimary: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color:
              isPrimary ? AppColors.primaryMedium : Colors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.primaryMedium.withAlpha(127),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
