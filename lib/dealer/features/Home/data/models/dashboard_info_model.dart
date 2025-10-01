// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DealerDashboardInfo {
  final Messages? messages;
  final Cars? cars;
  final Reels? reels;
  final int? ratings;

  DealerDashboardInfo({this.messages, this.cars, this.reels, this.ratings});

  DealerDashboardInfo copyWith({
    Messages? messages,
    Cars? cars,
    Reels? reels,
    int? ratings,
  }) => DealerDashboardInfo(
    messages: messages ?? this.messages,
    cars: cars ?? this.cars,
    reels: reels ?? this.reels,
    ratings: ratings ?? this.ratings,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages?.toMap(),
      'cars': cars?.toMap(),
      'reels': reels?.toMap(),
      'ratings': ratings,
    };
  }

  factory DealerDashboardInfo.fromMap(Map<String, dynamic> map) {
    return DealerDashboardInfo(
      messages: Messages.fromMap(map['messages'] as Map<String, dynamic>),
      cars: Cars.fromMap(map['cars'] as Map<String, dynamic>),
      reels: Reels.fromMap(map['reels'] as Map<String, dynamic>),
      ratings: map['ratings'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerDashboardInfo.fromJson(String source) =>
      DealerDashboardInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Cars {
  final int active;
  final int sold;
  final int archived;
  final int topRating;
  final List<dynamic> list;

  Cars({
    required this.active,
    required this.sold,
    required this.archived,
    required this.topRating,
    required this.list,
  });

  Cars copyWith({
    int? active,
    int? sold,
    int? archived,
    int? topRating,
    List<dynamic>? list,
  }) => Cars(
    active: active ?? this.active,
    sold: sold ?? this.sold,
    archived: archived ?? this.archived,
    topRating: topRating ?? this.topRating,
    list: list ?? this.list,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'active': active,
      'sold': sold,
      'archived': archived,
      'topRating': topRating,
      'list': list,
    };
  }

  factory Cars.fromMap(Map<String, dynamic> map) {
    return Cars(
      active: map['active'] as int,
      sold: map['sold'] as int,
      archived: map['archived'] as int,
      topRating: map['top_rating'] as int,
      list: List<dynamic>.from((map['list'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cars.fromJson(String source) =>
      Cars.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Messages {
  final int messagesNew;

  Messages({required this.messagesNew});

  Messages copyWith({int? messagesNew}) =>
      Messages(messagesNew: messagesNew ?? this.messagesNew);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'messagesNew': messagesNew};
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(messagesNew: map['new'] as int);
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) =>
      Messages.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Reels {
  final int views;
  final int likes;

  Reels({required this.views, required this.likes});

  Reels copyWith({int? views, int? likes}) =>
      Reels(views: views ?? this.views, likes: likes ?? this.likes);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'views': views, 'likes': likes};
  }

  factory Reels.fromMap(Map<String, dynamic> map) {
    return Reels(views: map['views'] as int, likes: map['likes'] as int);
  }

  String toJson() => json.encode(toMap());

  factory Reels.fromJson(String source) =>
      Reels.fromMap(json.decode(source) as Map<String, dynamic>);
}
