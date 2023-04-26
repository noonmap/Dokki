class Sort {
  Sort({
    required this.sorted,
    required this.unsorted,
    required this.empty,
  });

  final bool sorted;
  final bool unsorted;
  final bool empty;

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        sorted: json["sorted"],
        unsorted: json["unsorted"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "sorted": sorted,
        "unsorted": unsorted,
        "empty": empty,
      };
}
