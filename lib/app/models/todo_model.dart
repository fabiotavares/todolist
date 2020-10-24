import 'dart:convert';

class TodoModel {
  int id;
  String descricao;
  DateTime dataHora;
  bool finalizado;

  TodoModel({
    this.id,
    this.descricao,
    this.dataHora,
    this.finalizado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'data_hora': dataHora?.toIso8601String(),
      'finalizado': finalizado ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoModel(
      id: map['id'],
      descricao: map['descricao'],
      dataHora: DateTime.parse(map['data_hora']),
      finalizado: map['finalizado'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));
}
