// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dooss_business_app/dealer/Core/network/Base_Url.dart';
import 'package:dooss_business_app/dealer/Core/network/failure.dart';
import 'package:dooss_business_app/dealer/Core/network/service_locator.dart';
import 'package:dooss_business_app/dealer/features/reels/data/models/Reels_data_model.dart';
import 'package:image_picker/image_picker.dart';

class remouteDataReelsSource {
  final Dio dio;
  var header = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYxMTE4NjMzLCJpYXQiOjE3NTg1MjY2MzMsImp0aSI6ImM1MGM4NTAyMWM1MDRmYzdiY2JjYmIyMTJkOWQ3NjRiIiwidXNlcl9pZCI6IjIifQ.MUGK14YXsoxMUgEX83kSaaSoijjNfrcynoGM4s66e9k',
  };

  remouteDataReelsSource({required this.dio});
  Future<Either<String, List<ReelDataModel>>> getDataReels() async {
    try {
      print(getIt<Dio>().options.headers);
      var response = await dio.get(
        'http://10.0.2.2:8010/api/reels/my-reels/',
        options: Options(headers: header),
      );
      print(response.data);
      List<ReelDataModel> dataResponse = (response.data as List).map((item) {
        return ReelDataModel.fromMap(item);
      }).toList();

      return right(dataResponse);
    } catch (error) {
      print(error.toString());
      return left(error.toString());
    }
  }

  Future<Either<Failure, bool>> addNewReel(
    XFile? videoUrl,
    String title,
    String descraption,
  ) async {
    var url = 'http://10.0.2.2:8010/api/reels/';

    print(videoUrl!.path);
    var data = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        videoUrl.path,
        filename: videoUrl.name,
      ),
      'title': title,
      'description': descraption,
    });
    try {
      print('object');
      var response = await dio.request(
        url,
        data: data,
        options: Options(method: 'POST', headers: header),
      );
      // var response = await dio.post(
      //   url,
      //   options: Options(headers: header),
      //   data: data,
      // );
      print(response.data);
      print('okey');
      return right(true);
    } catch (e) {
      print(Failure.handleExcaption(e).massageError);
      if (e is DioException) {
        print(e.response!.data);
      }
      // print(e.toString());
      return left(Failure.handleExcaption(e));
    }
  }

  Future<Either<Failure, bool>> EditReel(
    int id,
    String title,
    String descraption,
    String? video,
    String? thumbnail,
  ) async {
    print(dio.options.headers);
    print(video);
    var data = FormData.fromMap({'title': title, 'description': descraption});
    // FormData formData = FormData({});
    if (video != null) {
      if (video.startsWith('http')) {
        // data.fields.add(MapEntry('video', video));
      } else {
        final file = File(video);
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        );
        data.files.add(MapEntry('video', multipartFile));
      }
    }
    print(data.fields);

    var url = 'http://10.0.2.2:8010/api/reels/$id/';
    // final file = File(video!);
    // var data = FormData.fromMap({'title': title, 'description': descraption});
    // var dataWithVidoe = FormData.fromMap({
    //   'video': [await MultipartFile.fromFile(video, filename: video)],
    //   // 'thumbnail': [
    //   //   await MultipartFile.fromFile(
    //   //     '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-22 020529.png',
    //   //     filename:
    //   //         '/C:/Users/ASUS/Pictures/Screenshots/لقطة شاشة 2025-09-22 020529.png',
    //   //   ),
    //   // ],
    //   'title': title,
    //   'description': descraption,
    // });
    //  /
    try {
      var response = await dio.request(
        'http://10.0.2.2:8010/api/reels/$id/',
        options: Options(
          method: 'PATCH',
          // headers: header
        ),
        data: data,
      );
      // EditReelsModels dataResponse = EditReelsModels.fromMap(response.data);
      print(response.data);
      return right(true);
    } catch (error) {
      if (error is DioException) {
        print(error.response!.statusMessage);
      }
      print(error.toString());
      return left(Failure.handleExcaption(error));
    }
  }

  Future<Either<Failure, bool>> deleteReel(int id) async {
    var url = 'http://10.0.2.2:8010/api/reels/$id/';
    try {
      var response = await dio.delete(
        url,
        //  options: Options(headers: header)
      );
      if (response.statusCode == 204) {
        return right(true);
      } else {
        return left(Failure(massageError: 'Error Dalete'));
      }
    } catch (e) {
      print(e.toString());
      return left(Failure.handleExcaption(e));
    }
  }
}

class EditReelsModels {
  final String title;
  final String description;
  // final String? thumbnail;
  final String? video;
  final bool isActive;

  EditReelsModels({
    required this.title,
    required this.description,
    // required this.thumbnail,
    required this.video,
    required this.isActive,
  });

  EditReelsModels copyWith({
    String? title,
    String? description,
    // String? thumbnail,
    String? video,
    bool? isActive,
  }) {
    return EditReelsModels(
      title: title ?? this.title,
      description: description ?? this.description,
      // thumbnail: thumbnail ?? this.thumbnail,
      video: video ?? this.video,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      // 'thumbnail': thumbnail,
      'video': video,
      'isActive': isActive,
    };
  }

  factory EditReelsModels.fromMap(Map<String, dynamic> map) {
    return EditReelsModels(
      title: map['title'] as String,
      description: map['description'] as String,
      // thumbnail: map['thumbnail'] as String ?? '',
      video: map['video'] as String ?? '',
      isActive: map['is_active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory EditReelsModels.fromJson(String source) =>
      EditReelsModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
