class SocketMessageModel {
  final String type;
  final int sender;
  final String text;
  final String timestamp;
  final int messageId;
  final String messageType;
  final String status;
  final String imageUrl;
  final String fileUrl;
  final int? fileSize;

  const SocketMessageModel({
    required this.type,
    required this.sender,
    required this.text,
    required this.timestamp,
    required this.messageId,
    required this.messageType,
    required this.status,
    required this.imageUrl,
    required this.fileUrl,
    this.fileSize,
  });

  factory SocketMessageModel.fromJson(Map<String, dynamic> json) {
    return SocketMessageModel(
      type: json['type'] ?? '',
      sender: json['sender'] is int
          ? json['sender']
          : int.tryParse(json['sender'].toString()) ?? 0,
      text: json['text']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
      messageId: json['message_id'] is int
          ? json['message_id']
          : int.tryParse(json['message_id'].toString()) ?? 0,
      messageType: json['message_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
      fileSize: json['file_size'] == null
          ? null
          : (json['file_size'] is int
              ? json['file_size']
              : int.tryParse(json['file_size'].toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
      'message_id': messageId,
      'message_type': messageType,
      'status': status,
      'image_url': imageUrl,
      'file_url': fileUrl,
      'file_size': fileSize,
    };
  }
}
