class CountryModel {
  final String code;
  final String name;
  final List<String> states;

  CountryModel({
    required this.code,
    required this.name,
    required this.states,
  });

  factory CountryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CountryModel(
      code: json['code'] as String,
      name: json['name'] as String,
      states: List<String>.from(
        json['states'] as List,
      ),
    );
  }
}
