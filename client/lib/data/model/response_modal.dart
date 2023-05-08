class ResponseModal {
  ResponseModal({
    required this.status,
    required this.data,
  });

  final int status;
  final dynamic data;

  factory ResponseModal.fromJson(Map<String, dynamic> json) =>
      ResponseModal(status: json["status"], data: json["data"]);

  @override
  String toString() {
    return 'ResponseModal{status: $status, data: $data}';
  }
}
