import 'package:json_annotation/json_annotation.dart';
import 'api_base_response.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends ApiBaseResponse{
  LoginResponse(success,message,this.uid, this.email, this.name) : super(success,message);

  @JsonKey(name: "uid")
  final String uid;
  final String email;
  final String name;


  factory LoginResponse.fromJson(Map<String,dynamic> json)=> _$LoginResponseFromJson(json);

  Map<String,dynamic> toJson()=> _$LoginResponseToJson(this);

}