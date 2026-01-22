import 'dart:io';
import 'dart:math'; // Add math
import 'package:flutter/foundation.dart'; // For kIsWeb

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/notification_service.dart'; // Add NotificationService
import '../../../core/theme/app_colors.dart';
import '../../../core/services/hybrid_fish_service.dart';
import '../../history/data/scan_history_model.dart';
import '../../history/data/history_repository.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/fluid_background.dart';
import '../../../core/widgets/bubble_splash.dart';
import 'result_screen.dart';
import '../../history/presentation/aquarium_screen.dart';
import '../../../core/widgets/glass_drawer.dart';
import '../../profile/presentation/profile_screen.dart';
import 'widgets/bio_sonar_scanner.dart';
import '../../settings/presentation/settings_screen.dart'; // Add Settings Import

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Added GlobalKey
  final ImagePicker _picker = ImagePicker();
  final HybridFishService _fishService = HybridFishService();
  final HistoryRepository _historyRepo = HistoryRepository();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  String? _errorMessage;
  
  int _totalScans = 0;
  int _aquariumCount = 0;

  // Daily Fact
  String _dailyFact = "মাছ ধরার আগে আবহাওয়া চেক করুন।";

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadDailyFact();
    _rescheduleDailyNotification();
  }

  Future<void> _rescheduleDailyNotification() async {
    // Reschedule to ensure a fresh random fact is set for the next notification
    if (await NotificationService().areNotificationsEnabled()) {
      await NotificationService().scheduleDailyFishFact();
    }
  }

  void _loadDailyFact() {
    const facts = NotificationService.fishFacts;
    if (facts.isNotEmpty) {
      setState(() {
        _dailyFact = facts[Random().nextInt(facts.length)]['bn'] ?? _dailyFact;
      });
    }
  }
  
  Future<void> _loadStats() async {
    final scans = await _historyRepo.getScanCount();
    final species = await _historyRepo.getUniqueSpeciesCount();
    if (mounted) {
      setState(() {
        _totalScans = scans;
        _aquariumCount = species;
      });
    }
  }

  @override
  void dispose() {
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

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    // Start location fetch in parallel with AI analysis
    final locationFuture = _determinePosition();
    
    final result = await _fishService.identifyFish(_selectedImage!);

    // Save to History (Real Persistence)
    if (result.isIdentified) {
      try {
        // Wait for location result (should be nearly done by now)
        Position? position; 
        try {
          position = await locationFuture;
        } catch (locErr) {
          debugPrint("Location error: $locErr");
        }

        await _historyRepo.saveScan(ScanRecord(
          fishLocalName: result.localNameBangla,
          fishScientificName: result.scientificName,
          confidence: result.confidence,
          imagePath: _selectedImage!.path,
          timestamp: DateTime.now(),
          latitude: position?.latitude,
          longitude: position?.longitude,
        ));
        await _loadStats(); // Refresh stats
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
      key: _scaffoldKey, // Assign Key
      extendBodyBehindAppBar: true,
      drawer: const GlassDrawer(),
      body: FluidBackground(
        child: BubbleSplash(
          child: SafeArea(
            bottom: false,
            child: _selectedImage == null
                ? _buildHomeUI()
                : _buildImagePreviewUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 45, height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(image: AssetImage('assets/images/app_icon.jpg'), fit: BoxFit.cover),
                  border: Border.all(color: Colors.white38, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('মৎস্য ওস্তাদ', style: GoogleFonts.hindSiliguri(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('MATSHO OSTAD', style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5)),
                ],
              ),
              const Spacer(),
              GlassContainer(
                width: 42, height: 42, padding: EdgeInsets.zero, borderRadius: 12,
                child: const Icon(Icons.settings, color: Colors.white70),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
              ),
              const SizedBox(width: 8),
              GlassContainer(
                width: 42, height: 42, padding: EdgeInsets.zero, borderRadius: 12,
                child: const Icon(Icons.menu, color: Colors.white),
                onTap: () => _scaffoldKey.currentState?.openDrawer(), // Use Key
              ),
            ],
          ),

          // Spacer instead of fixed size for flexibility
          const SizedBox(height: 15),

          // Stats Cards (Compact)
          Row(
            children: [
              Expanded(child: _buildStatCard(
                title: 'মোট স্ক্যান', subtitle: 'Total Scans', value: '$_totalScans', icon: Icons.qr_code_scanner,
                onTap: _loadStats, // Make it refresh stats
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(
                title: 'আমার মাছঘর', subtitle: 'My Aquarium', value: '$_aquariumCount', icon: Icons.set_meal,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AquariumScreen())).then((_) => _loadStats()),
              )),
            ],
          ),

          const Spacer(), // Pushes Scanner to center vertically

          // MAIN SCANNER (Reduced Size)
          Transform.scale(
            scale: 0.9, 
            child: Hero(
              tag: 'scanner_hero',
              child: BioSonarScanner(onTap: _pickImageFromCamera, isScanning: _isAnalyzing),
            ),
          ),
          
          Text("Tap to scan", style: GoogleFonts.outfit(color: Colors.white54, fontSize: 12)),

          const Spacer(),

          // Features Row (Side by Side)
          SizedBox(
            height: 100, // Fixed height container for features
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Confusion Breaker (Small)
                Expanded(
                  child: _buildCompactFeatureCard(
                    icon: Icons.lightbulb_outline,
                    title: 'বিভ্রান্তি',
                    subtitle: 'Confusion',
                    color: AppColors.accentCoral,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1F2C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Row(children: [Icon(Icons.lightbulb_outline, color: AppColors.accentCoral), SizedBox(width: 10), Text("Confusion Breaker", style: TextStyle(color: Colors.white))]),
                          content: const Text("Scan a fish to see if it's often confused with another species! This feature appears on the Result Screen.", style: TextStyle(color: Colors.white70)),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Got it"))],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Daily Fact (Small)
                Expanded(
                  flex: 2, // Give more space to text
                  child: GlassContainer(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_stories, color: AppColors.accentGold, size: 16),
                            SizedBox(width: 6),
                            Text('দৈনিক তথ্য', style: TextStyle(color: AppColors.accentGold, fontSize: 12, fontFamily: 'Hind Siliguri', fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dailyFact,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withAlpha(220), fontSize: 11, fontFamily: 'Hind Siliguri'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Developer Credit
          Text("Developed by Sarfaraz Ahamed Shovon", style: GoogleFonts.outfit(color: Colors.white30, fontSize: 10)),

          const SizedBox(height: 10),

          // Bottom Glass Navigation
          SizedBox(
            height: 70,
            child: GlassContainer(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_filled, "Home", true),
                  _buildNavItem(Icons.camera_alt, "Scan", false, onTap: _pickImageFromCamera),
                  _buildNavItem(Icons.photo_library_outlined, "Gallery", false, onTap: _pickImageFromGallery),
                  _buildNavItem(Icons.person_outline, "Profile", false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Compact Feature Card
  Widget _buildCompactFeatureCard({required IconData icon, required String title, required String subtitle, required Color color, VoidCallback? onTap}) {
    return GlassContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.hindSiliguri(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(subtitle, style: GoogleFonts.outfit(color: Colors.white54, fontSize: 8)),
        ],
      ),
    );
  }

  // GPS Location Helper
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // Location services are disabled.
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Permissions are denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // Permissions are denied forever
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
      return null;
    }
  }

  Widget _buildStatCard({ // Modified for compactness
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      height: 85, // Reduced height
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.accentCoral, size: 20),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.hindSiliguri(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: isSelected ? BoxDecoration(
              color: Colors.white.withAlpha(50),
              shape: BoxShape.circle,
            ) : null,
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: 24,
            ),
          ),
          if (isSelected) 
             Container(
               margin: const EdgeInsets.only(top: 4),
               width: 4, height: 4, 
               decoration: const BoxDecoration(color: AppColors.accentCoral, shape: BoxShape.circle),
             ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewUI() {
    return Column(
      children: [
        // Custom Header for Preview
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlassContainer(
                width: 45, height: 45, padding: EdgeInsets.zero, borderRadius: 12,
                child: const Icon(Icons.arrow_back, color: Colors.white),
                onTap: () => setState(() { _selectedImage = null; _errorMessage = null; }),
              ),
              const Text("Preview", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 45), // Balance
            ],
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
               boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 20),
               ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  kIsWeb
                      ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                      : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                  
                  // Scanning Overlay
                  if (_isAnalyzing)
                    Container(
                      color: Colors.black.withAlpha(100),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.accentCoral),
                      ),
                    ),

                   // Error Overlay
                  if (_errorMessage != null)
                    Center(
                      child: GlassContainer(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error, color: AppColors.accentCoral, size: 40),
                            const SizedBox(height: 10),
                            Text(_errorMessage!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: Row(
            children: [
              Expanded(
                child: GlassContainer(
                  height: 60,
                  onTap: () => setState(() { _selectedImage = null; _errorMessage = null; }),
                  child: const Center(child: Text("Retake", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: _analyzeImage,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.accentCoral, Colors.orangeAccent]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: AppColors.accentCoral.withAlpha(100), blurRadius: 15, offset: const Offset(0,5)),
                      ],
                    ),
                    child: const Center(child: Text("Identify Fish", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
