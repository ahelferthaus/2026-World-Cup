class TeamModel {
  final int id;
  final String name;
  final String logo;

  const TeamModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }
}
