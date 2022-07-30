import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supper_vip_pro_poll_flutter_mobile_cross_platform/models/poll_model.dart';

class VotingPoll extends StatefulWidget {
  const VotingPoll({Key? key}) : super(key: key);

  @override
  State<VotingPoll> createState() => _VotingPollState();
}

class _VotingPollState extends State<VotingPoll> {
  List<Poll> polls = [];
  DatabaseReference refUp = FirebaseDatabase.instance.ref("data");

  @override
  void initState() {
    super.initState();
    initPollStream();
  }

  void initPollStream() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data");

    // Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;
    // Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      String data = json.encode(event.snapshot.value);
      List listPoll = json.decode(data);
      var snapshotValue = (listPoll).where((element) => element != null);

      setState(() {
        polls = (snapshotValue).map((value) => Poll.fromJson(value)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Polls')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: () async => setState(() => polls = polls),
          child: ListView.builder(
            itemCount: polls.length,
            itemBuilder: (BuildContext context, int index) {
              Poll poll = polls[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: FlutterPolls(
                  pollId: poll.pollId.toString(),
                  onVoted: (PollOption pollOption, int newTotalVotes) async {
                    print('Voted');
                    var procesed_index = index + 1;
                    var procesed_vote = pollOption.id! - 1;
                    await refUp.update({
                      "$procesed_index/options/${procesed_vote}/votes":
                          pollOption.votes + 1
                    });
                    print("$procesed_index/options/${procesed_vote}/votes");
                    return Future.value(true);
                  },
                  pollTitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      poll.question ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  pollOptions: poll.options != null
                      ? List<PollOption>.from(
                          poll.options!.map(
                            (option) {
                              var a = PollOption(
                                id: option.id,
                                title: Text(
                                  option.title ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                votes: option.votes ?? 0,
                              );
                              return a;
                            },
                          ),
                        )
                      : List<PollOption>.from([]),
                  votedPercentageTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  metaWidget: Row(
                    children: const [
                      SizedBox(width: 6),
                      SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
