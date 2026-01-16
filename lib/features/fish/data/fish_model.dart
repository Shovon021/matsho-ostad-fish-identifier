import 'package:equatable/equatable.dart';

class Fish extends Equatable {
  final int id;
  final String localName;
  final String scientificName;
  final String habitat;
  final String description;
  final String imageAsset;
  final List<String> identificationMarkers;
  final int? visualClusterId;

  const Fish({
    required this.id,
    required this.localName,
    required this.scientificName,
    required this.habitat,
    required this.description,
    required this.imageAsset,
    required this.identificationMarkers,
    this.visualClusterId,
  });

  @override
  List<Object?> get props => [
        id,
        localName,
        scientificName,
        habitat,
        description,
        imageAsset,
        identificationMarkers,
        visualClusterId,
      ];

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'] as int,
      localName: json['local_name'] as String,
      scientificName: json['scientific_name'] as String,
      habitat: json['habitat'] as String,
      description: json['description'] as String,
      imageAsset: json['image_asset'] as String,
      identificationMarkers:
          List<String>.from(json['identification_markers'] ?? []),
      visualClusterId: json['visual_cluster_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'local_name': localName,
      'scientific_name': scientificName,
      'habitat': habitat,
      'description': description,
      'image_asset': imageAsset,
      'identification_markers': identificationMarkers,
      'visual_cluster_id': visualClusterId,
    };
  }
}

class VisualCluster extends Equatable {
  final int id;
  final String name;
  final List<int> fishIds;

  const VisualCluster({
    required this.id,
    required this.name,
    required this.fishIds,
  });

  @override
  List<Object?> get props => [id, name, fishIds];
}

class ConfusionPair extends Equatable {
  final int fishId1;
  final int fishId2;
  final String distinguishingFeatureText;

  const ConfusionPair({
    required this.fishId1,
    required this.fishId2,
    required this.distinguishingFeatureText,
  });

  @override
  List<Object?> get props => [fishId1, fishId2, distinguishingFeatureText];
}
