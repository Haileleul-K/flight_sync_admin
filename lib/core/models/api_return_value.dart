class ApiReturnValue<T> {
  final T? data;
  final String? status;
  final String? message;

  ApiReturnValue({this.status, this.message, this.data,});

  factory ApiReturnValue.fromMap(Map<String, dynamic> json) {
    return ApiReturnValue<T>(
      data:json['data'],
      // List<Map<String,dynamic>>.from((json['data'] as List<dynamic>).map((e) => Map<String,dynamic>.from(e as Map<String,dynamic>))) 
      status: json['status'] != null ? json['status'] as String : null,
      message: json['message'] != null ? json['message'] as String : null,
    );
  }
}
