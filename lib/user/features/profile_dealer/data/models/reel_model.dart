class ReelModel {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String videoUrl;
  final int viewsCount;
  final int likesCount;
  final String dealerId;
  final DateTime createdAt;

  const ReelModel({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.viewsCount,
    required this.likesCount,
    required this.dealerId,
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    DateTime parseCreatedAt(dynamic createdAt) {
      try {
        if (createdAt is String) {
          return DateTime.parse(createdAt);
        } else if (createdAt is DateTime) {
          return createdAt;
        } else {
          return DateTime.now();
        }
      } catch (e) {
        print('⚠️ Error parsing createdAt: $createdAt, error: $e');
        return DateTime.now();
      }
    }

    int parseCount(dynamic count) {
      try {
        if (count is int) {
          return count;
        } else if (count is String) {
          return int.tryParse(count) ?? 0;
        } else if (count is double) {
          return count.toInt();
        } else {
          return 0;
        }
      } catch (e) {
        print('⚠️ Error parsing count: $count, error: $e');
        return 0;
      }
    }

    return ReelModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      viewsCount: parseCount(json['views_count']),
      likesCount: parseCount(json['likes_count']),
      dealerId: json['dealer_id']?.toString() ?? '',
      createdAt: parseCreatedAt(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'dealer_id': dealerId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReelModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.thumbnailUrl == thumbnailUrl &&
        other.videoUrl == videoUrl &&
        other.viewsCount == viewsCount &&
        other.likesCount == likesCount &&
        other.dealerId == dealerId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      thumbnailUrl,
      videoUrl,
      viewsCount,
      likesCount,
      dealerId,
      createdAt,
    );
  }
}
