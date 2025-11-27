class AnswerModel {
  String? answer;
  String? id;
  String? problem;

  AnswerModel({this.answer, this.id, this.problem});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answer: json['answer'] as String?,
      id: json['id'] as String?,
      problem: json['problem'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {"answer": answer, "id": id, "problem": problem};
  }
}
