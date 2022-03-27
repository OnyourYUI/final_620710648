class ApiResult{
  final String status;
  final String? msg;
  final dynamic data;

  ApiResult({
    required this.status,
    required this.msg,
    required this.data,
});

  factory ApiResult.fromJson(Map<String, dynamic> json){
    return ApiResult(
      status: json["status"],
      msg: json["msg"],
      data: json["data"],
    );
  }
}