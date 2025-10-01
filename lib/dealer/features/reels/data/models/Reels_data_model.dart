// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReelDataModel {
  int id;
  bool liked;
  String dealerName;
  dynamic dealerAvatar;
  dynamic video;
  dynamic thumbnail;
  String title;
  String description;
  bool isActive;
  int viewsCount;
  int likesCount;

  dynamic deletedAt;
  int dealer;

  ReelDataModel({
    required this.id,
    required this.liked,
    required this.dealerName,
    required this.dealerAvatar,
    required this.video,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.isActive,
    required this.viewsCount,
    required this.likesCount,

    required this.deletedAt,
    required this.dealer,
  });

  ReelDataModel copyWith({
    int? id,
    bool? liked,
    String? dealerName,
    dynamic dealerAvatar,
    dynamic video,
    dynamic thumbnail,
    String? title,
    String? description,
    bool? isActive,
    int? viewsCount,
    int? likesCount,

    dynamic deletedAt,
    int? dealer,
  }) => ReelDataModel(
    id: id ?? this.id,
    liked: liked ?? this.liked,
    dealerName: dealerName ?? this.dealerName,
    dealerAvatar: dealerAvatar ?? this.dealerAvatar,
    video: video ?? this.video,
    thumbnail: thumbnail ?? this.thumbnail,
    title: title ?? this.title,
    description: description ?? this.description,
    isActive: isActive ?? this.isActive,
    viewsCount: viewsCount ?? this.viewsCount,
    likesCount: likesCount ?? this.likesCount,
    deletedAt: deletedAt ?? this.deletedAt,
    dealer: dealer ?? this.dealer,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'liked': liked,
      'dealerName': dealerName,
      'dealerAvatar': dealerAvatar,
      'video': video,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'isActive': isActive,
      'viewsCount': viewsCount,
      'likesCount': likesCount,

      'deletedAt': deletedAt,
      'dealer': dealer,
    };
  }

  factory ReelDataModel.fromMap(Map<String, dynamic> map) {
    return ReelDataModel(
      id: map['id'] as int,
      liked: map['liked'] as bool,
      dealerName: map['dealer_name'] as String,
      dealerAvatar: map['dealer_avatar'] as dynamic,
      video: map['video'] as dynamic,
      thumbnail: map['thumbnail'] as dynamic,
      title: map['title'] as String,
      description: map['description'] as String,
      isActive: map['is_active'] as bool,
      viewsCount: map['views_count'] as int,
      likesCount: map['likes_count'] as int,
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      deletedAt: map['deleted_at'] as dynamic,
      dealer: map['dealer'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReelDataModel.fromJson(String source) =>
      ReelDataModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
