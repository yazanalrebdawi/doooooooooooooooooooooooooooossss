class DealerModel {
  final String id;
  final String name;
  final String handle;
  final String? profileImage;
  final String? description;
  final int reelsCount;
  final bool isVerified;
  final int? userId; // User ID for creating chats

  const DealerModel({
    required this.id,
    required this.name,
    required this.handle,
    this.profileImage,
    this.description,
    required this.reelsCount,
    this.isVerified = false,
    this.userId,
  });

  factory DealerModel.fromJson(Map<String, dynamic> json) {
    // Try to get user_id from various possible fields
    int? userId;

    // Debug: print all keys to see what's available
    print('🔍 DealerModel.fromJson: Available keys: ${json.keys.toList()}');

    if (json['user_id'] != null) {
      print(
          '🔍 DealerModel.fromJson: Found user_id: ${json['user_id']} (type: ${json['user_id'].runtimeType})');
      userId = json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString());
    } else if (json['user'] != null) {
      print(
          '🔍 DealerModel.fromJson: Found user: ${json['user']} (type: ${json['user'].runtimeType})');
      // If user is an object, get its id
      if (json['user'] is Map && json['user']['id'] != null) {
        userId = json['user']['id'] is int
            ? json['user']['id']
            : int.tryParse(json['user']['id'].toString());
      } else if (json['user'] is int) {
        userId = json['user'];
      } else if (json['user'] != null) {
        userId = int.tryParse(json['user'].toString());
      }
    } else {
      print('🔍 DealerModel.fromJson: No user_id or user field found');
    }

    print('🔍 DealerModel.fromJson: Extracted userId: $userId');

    return DealerModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      handle: json['handle'] ?? '',
      profileImage: json['profile_image'],
      description: json['description'],
      reelsCount: json['reels_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      userId: userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'profile_image': profileImage,
      'description': description,
      'reels_count': reelsCount,
      'is_verified': isVerified,
      'user_id': userId,
    };
  }

  DealerModel copyWith({
    String? id,
    String? name,
    String? handle,
    String? profileImage,
    String? description,
    int? reelsCount,
    bool? isVerified,
    int? userId,
  }) {
    return DealerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      profileImage: profileImage ?? this.profileImage,
      description: description ?? this.description,
      reelsCount: reelsCount ?? this.reelsCount,
      isVerified: isVerified ?? this.isVerified,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DealerModel &&
        other.id == id &&
        other.name == name &&
        other.handle == handle &&
        other.profileImage == profileImage &&
        other.description == description &&
        other.reelsCount == reelsCount &&
        other.isVerified == isVerified &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      handle,
      profileImage,
      description,
      reelsCount,
      isVerified,
      userId,
    );
  }
}
