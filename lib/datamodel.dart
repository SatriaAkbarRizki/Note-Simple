class DataModel {
  int? id;
  String name, description, create_at, update_at;

  DataModel(
      this.id, this.name, this.description, this.create_at, this.update_at);

  factory DataModel.fromJson(Map<String, dynamic>? json) => DataModel(
      json?['id'],
      json?['name'],
      json?['description'],
      json?['create_at'],
      json?['update_at']);
}
