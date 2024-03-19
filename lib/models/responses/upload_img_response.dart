import 'package:json_annotation/json_annotation.dart';

import 'api_base_response.dart';

part 'upload_img_response.g.dart';

@JsonSerializable()
class UploadImgResponse extends ApiBaseResponse {
  UploadImgResponse(bool success,String message, this.image) : super(success,message);

 // @JsonKey(name: "uid")
  final String image;


  factory UploadImgResponse.fromJson(Map<String,dynamic> json)=> _$UploadImgResponseFromJson(json);

  Map<String,dynamic> toJson()=> _$UploadImgResponseToJson(this);

}