class ScanRecord {
  final int? id;
  final String fishLocalName;
  final String fishScientificName;
  final double confidence;
  final String imagePath;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  ScanRecord({
    this.id,
    required this.fishLocalName,
    required this.fishScientificName,
    required this.confidence,
    required this.imagePath,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fish_local_name': fishLocalName,
      'fish_scientific_name': fishScientificName,
      'confidence': confidence,
      'image_path': imagePath,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'is_verified': 1,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      id: map['id'],
      fishLocalName: map['fish_local_name'],
      fishScientificName: map['fish_scientific_name'],
      confidence: map['confidence'],
      imagePath: map['image_path'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
