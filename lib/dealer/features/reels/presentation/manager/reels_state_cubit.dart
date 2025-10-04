// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/Reels_data_model.dart';
import '../../data/remoute_data_reels_source.dart';

class ReelsStateCubit extends Cubit<reelsState> {
  final remouteDataReelsSource data;
  ReelsStateCubit(this.data)
    : super(reelsState(allReels: [], video: XFile('')));
  void getDataReels() async {
    var result = await data.getDataReels();
    result.fold((error) {}, (data) {
      print(data.length);
      emit(state.copyWith(allReels: data));
    });
  }

  void togglelikeReel(int id) {
    List<ReelDataModel> allReels = List.from(state.allReels);
    int index = allReels.indexWhere((item) => item.id == id);
    ReelDataModel CurrentReel = allReels[index];
    ReelDataModel editReel = CurrentReel.copyWith(liked: !CurrentReel.liked);
    // allReels.insert(index, editReel);
    allReels[index] = editReel;
    emit(state.copyWith(allReels: allReels));
  }

  void setVidoeValue(XFile? video) {
    emit(state.copyWith(video: video));
  }

  void AddNewReel(XFile? video, String title, String descraption) async {
    var result = await data.addNewReel(video, title, descraption);
    result.fold(
      (failure) {
        print(failure.message);
        if(failure.statusCode==400){
              emit(state.copyWith(error: 'You have reached your monthly reel publishing quota'));
        }else{
   emit(state.copyWith(error: failure.message));
        }
        
     
      },
      (isSuccess) {
        emit(state.copyWith(isSuccess: isSuccess));
      },
    );
  }

  void EditDataReel(
    int id,
    String title,
    String descraption,
    String video,
    String? thumbnail,
  ) async {
    print(video);
    var result = await data.EditReel(id, title, descraption, video, thumbnail);
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (DataResponse) {
        // List<ReelDataModel> allReels = List.from(state.allReels);
        // int index = allReels.indexWhere((item) => item.id == id);
        // allReels[index].copyWith(
        //   title: DataResponse.title,
        //   description: DataResponse.description,
        //   video: DataResponse.video,
        //   thumbnail: DataResponse.thumbnail,
        // );
        emit(state.copyWith(isSuccess: true));
      },
    );
  }

  void deleteReel(int id) async {
    List<ReelDataModel> all = List.from(state.allReels);
    int index = all.indexWhere((item) => item.id == id);
    ReelDataModel CurrentReel = all[index];
    all.removeAt(index);
    emit(state.copyWith(allReels: all));
    var result = await data.deleteReel(id);
    result.fold(
      (e) {
        all.insert(index, CurrentReel);
        emit(state.copyWith(error: e.message, allReels: all));
      },
      (isSuccess) {
        emit(state.copyWith(isSuccess: isSuccess));
      },
    );
  }
}

class reelsState {
  final bool? isLoading;
  final String? error;
  final List<ReelDataModel> allReels;
  final bool? isLikedReel;
  final XFile? video;
  final bool? isSuccess;

  reelsState({
    this.isLoading,
    this.error,
    required this.allReels,
    this.isLikedReel = false,
    this.video,
    this.isSuccess,
  });

  reelsState copyWith({
    bool? isLoading,
    String? error,
    List<ReelDataModel>? allReels,
    bool? isLikedReel,
    XFile? video,
    bool? isSuccess,
  }) {
    return reelsState(
      isLoading: isLoading ?? false,
      error: error,
      allReels: allReels ?? this.allReels,
      isLikedReel: isLikedReel ?? this.isLikedReel,
      video: video,
      isSuccess: isSuccess ?? false,
    );
  }
}
