// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_img_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImgResponse _$UploadImgResponseFromJson(Map<String, dynamic> json) =>
    UploadImgResponse(
      json['success'] as bool,
      json['message'] as String,
      json['image'] as String,
    );

Map<String, dynamic> _$UploadImgResponseToJson(UploadImgResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'image': instance.image,
    };
