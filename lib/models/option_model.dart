class Option {
  int? id;
  String? title;
  int? votes;

  Option({this.id, this.title, this.votes});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    votes = json['votes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['votes'] = this.votes;
    return data;
  }
}
