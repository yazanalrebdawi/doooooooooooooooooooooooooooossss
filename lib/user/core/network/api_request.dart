class ApiRequest<T> {
  final String url;
  final T? data;
  final String? token;
  // final T Function(Map<String, dynamic>)? parser;
  ApiRequest({
    required this.url,
    this.data,
    this.token,
    // this.parser,
  });
}
