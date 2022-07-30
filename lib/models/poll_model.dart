import 'package:supper_vip_pro_poll_flutter_mobile_cross_platform/models/option_model.dart';

class Poll {
  int? pollId;
  String? question;
  List<Option>? options;

  Poll({this.pollId, this.question, this.options});

  Poll.fromJson(Map<String, dynamic> json) {
    pollId = json['poll_id'];
    question = json['question'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['poll_id'] = pollId;
    data['question'] = question;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
