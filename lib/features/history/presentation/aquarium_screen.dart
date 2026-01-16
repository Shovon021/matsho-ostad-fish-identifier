import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fluid_background.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../history/data/history_repository.dart';
import '../../history/data/scan_history_model.dart';

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({super.key});

  @override
  State<AquariumScreen> createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> {
  final HistoryRepository _repository = HistoryRepository();
  late Future<List<ScanRecord>> _fishFuture;

  @override
  void initState() {
    super.initState();
    _fishFuture = _repository.getUniqueSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GlassContainer(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      borderRadius: 14,
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Aquarium',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Hind Siliguri',
                              ),
                        ),
                        Text(
                          'Your Collection',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: FutureBuilder<List<ScanRecord>>(
                  future: _fishFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.accentCoral));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: GlassContainer(
                          width: 300,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.waves,
                                  size: 60, color: Colors.white.withAlpha(100)),
                              const SizedBox(height: 16),
                              Text(
                                "Your tank is empty!",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Start scanning fish to add them here.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final fishList = snapshot.data!;

                    return GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: fishList.length,
                      itemBuilder: (context, index) {
                        final fish = fishList[index];
                        return _buildFishCard(context, fish);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFishCard(BuildContext context, ScanRecord fish) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Image Background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: kIsWeb
                  ? Image.network(
                      fish.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black.withAlpha(50),
                        child: const Icon(Icons.broken_image,
                            color: Colors.white54),
                      ),
                    )
                  : Image.file(
                      File(fish.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.black.withAlpha(50),
                        child: const Icon(Icons.broken_image,
                            color: Colors.white54),
                      ),
                    ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fish.fishLocalName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Hind Siliguri',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fish.fishScientificName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withAlpha(180),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentGold.withAlpha(100)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified,
                      size: 12, color: AppColors.accentGold),
                  const SizedBox(width: 4),
                  Text(
                    '${(fish.confidence * 100).toInt()}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
