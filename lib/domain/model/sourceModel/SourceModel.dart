class SourceModel {
  String? status;
  String? code;
  String? message;
  List<Sources>? sources;
  SourceModel({this.status, this.sources, this.code, this.message});
  SourceModel.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          code: json['code'] ?? '',
          message: json['message'] ?? '',
          sources: List<Sources>.from(
              json['sources'].map((e) => Sources.fromJson(e))),
        );
}

class Sources {
  String? id;
  String? name;
  String? description;
  String? url;
  String? category;

  Sources({
    this.id,
    this.name,
    this.description,
    this.url,
    this.category,
  });
  Sources.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          description: json['description'],
          url: json['url'],
          category: json['category'],
        );
}
