class DataModel {
  int? id;
  String title, description, create_at, update_at;

  DataModel(
      this.id, this.title, this.description, this.create_at, this.update_at);

  factory DataModel.fromJson(Map<String, dynamic>? json) => DataModel(
      json?['id'],
      json?['title'],
      json?['description'],
      json?['create_at'],
      json?['update_at']);
}
