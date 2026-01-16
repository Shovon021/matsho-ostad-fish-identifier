import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fluid_background.dart';
import '../../../core/widgets/glass_container.dart';
import '../../history/data/history_repository.dart';
import '../../history/data/scan_history_model.dart';

class CatchMapScreen extends StatefulWidget {
  const CatchMapScreen({super.key});

  @override
  State<CatchMapScreen> createState() => _CatchMapScreenState();
}

class _CatchMapScreenState extends State<CatchMapScreen> {
  final HistoryRepository _historyRepo = HistoryRepository();
  List<ScanRecord> _recordsWithLocation = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecordsWithLocation();
  }

  Future<void> _loadRecordsWithLocation() async {
    final allRecords = await _historyRepo.getRecentScans();
    final withLocation = allRecords
        .where((r) => r.latitude != null && r.longitude != null)
        .toList();
    setState(() {
      _recordsWithLocation = withLocation;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Default center: Bangladesh (Dhaka)
    const defaultCenter = LatLng(23.8103, 90.4125);
    
    final mapCenter = _recordsWithLocation.isNotEmpty
        ? LatLng(
            _recordsWithLocation.first.latitude!,
            _recordsWithLocation.first.longitude!,
          )
        : defaultCenter;

    return Scaffold(
      body: FluidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GlassContainer(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      borderRadius: 14,
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ক্যাচ ম্যাপ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Hind Siliguri',
                          ),
                        ),
                        Text(
                          'Catch Map',
                          style: TextStyle(
                            color: Colors.white.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GlassContainer(
                      width: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      borderRadius: 14,
                      child: Center(
                        child: Text(
                          '${_recordsWithLocation.length}',
                          style: const TextStyle(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Map
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentGold,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: mapCenter,
                            initialZoom: 10.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.matsho_ostad.app',
                            ),
                            MarkerLayer(
                              markers: _recordsWithLocation.map((record) {
                                return Marker(
                                  point: LatLng(
                                    record.latitude!,
                                    record.longitude!,
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () => _showRecordDetails(record),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryMedium,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(50),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.phishing,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecordDetails(ScanRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMedium.withAlpha(50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.phishing,
                    color: AppColors.primaryLight,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.fishLocalName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hind Siliguri',
                        ),
                      ),
                      Text(
                        record.fishScientificName,
                        style: TextStyle(
                          color: Colors.white.withAlpha(150),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.white.withAlpha(150), size: 18),
                const SizedBox(width: 8),
                Text(
                  '${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year}',
                  style: TextStyle(color: Colors.white.withAlpha(200)),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.location_on,
                    color: AppColors.accentCoral, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${record.latitude!.toStringAsFixed(4)}, ${record.longitude!.toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.white.withAlpha(200)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
