class DealerModel {
  final String id;
  final String name;
  final String handle;
  final String? profileImage;
  final String? description;
  final int reelsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final bool isFollowing;

  const DealerModel({
    required this.id,
    required this.name,
    required this.handle,
    this.profileImage,
    this.description,
    required this.reelsCount,
    required this.followersCount,
    required this.followingCount,
    this.isVerified = false,
    this.isFollowing = false,
  });

  factory DealerModel.fromJson(Map<String, dynamic> json) {
    return DealerModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      handle: json['handle'] ?? '',
      profileImage: json['profile_image'],
      description: json['description'],
      reelsCount: json['reels_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isFollowing: json['is_following'] ?? false,
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
      'followers_count': followersCount,
      'following_count': followingCount,
      'is_verified': isVerified,
      'is_following': isFollowing,
    };
  }

  DealerModel copyWith({
    String? id,
    String? name,
    String? handle,
    String? profileImage,
    String? description,
    int? reelsCount,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
    bool? isFollowing,
  }) {
    return DealerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      profileImage: profileImage ?? this.profileImage,
      description: description ?? this.description,
      reelsCount: reelsCount ?? this.reelsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
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
        other.followersCount == followersCount &&
        other.followingCount == followingCount &&
        other.isVerified == isVerified &&
        other.isFollowing == isFollowing;
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
      followersCount,
      followingCount,
      isVerified,
      isFollowing,
    );
  }
}
