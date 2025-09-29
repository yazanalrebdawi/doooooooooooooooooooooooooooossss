class ReelModel {
  final int id;
  final bool liked;
  final String video;
  final String thumbnail;
  final String title;
  final String description;
  final bool isActive;
  final int viewsCount;
  final int likesCount;
  final String createdAt;
  final String? deletedAt;
  final int dealer;
  final String? dealerName;
  final String? dealerUsername;
  final String? location;
  final String? audioTitle;

  const ReelModel({
    required this.id,
    required this.liked,
    required this.video,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.isActive,
    required this.viewsCount,
    required this.likesCount,
    required this.createdAt,
    this.deletedAt,
    required this.dealer,
    this.dealerName,
    this.dealerUsername,
    this.location,
    this.audioTitle,
  });

  ReelModel copyWith({
    int? id,
    bool? liked,
    String? video,
    String? thumbnail,
    String? title,
    String? description,
    bool? isActive,
    int? viewsCount,
    int? likesCount,
    String? createdAt,
    String? deletedAt,
    int? dealer,
    String? dealerName,
    String? dealerUsername,
    String? location,
    String? audioTitle,
  }) {
    return ReelModel(
      id: id ?? this.id,
      liked: liked ?? this.liked,
      video: video ?? this.video,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dealer: dealer ?? this.dealer,
      dealerName: dealerName ?? this.dealerName,
      dealerUsername: dealerUsername ?? this.dealerUsername,
      location: location ?? this.location,
      audioTitle: audioTitle ?? this.audioTitle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'liked': liked,
      'video': video,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'is_active': isActive,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'dealer': dealer,
      'dealer_name': dealerName,
      'dealer_username': dealerUsername,
      'location': location,
      'audio_title': audioTitle,
    };
  }

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] ?? 0,
      liked: json['liked'] ?? false,
      video: json['video'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      deletedAt: json['deleted_at'],
      dealer: json['dealer'] ?? 0,
      dealerName: json['dealer_name'],
      dealerUsername: json['dealer_username'],
      location: json['location'],
      audioTitle: json['audio_title'],
    );
  }
}

class ReelsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ReelModel> results;

  const ReelsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  ReelsResponseModel copyWith({
    int? count,
    String? next,
    String? previous,
    List<ReelModel>? results,
  }) {
    return ReelsResponseModel(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((reel) => reel.toJson()).toList(),
    };
  }

  factory ReelsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReelsResponseModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((reel) => ReelModel.fromJson(reel))
              .toList() ??
          [],
    );
  }
}
