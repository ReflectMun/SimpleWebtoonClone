import 'package:flutter/material.dart';
import '../models/webtoon_detail_model.dart';

class WebtoonInfo extends StatelessWidget {
  final AsyncSnapshot<WebtoonDetailModel> snapshot;

  const WebtoonInfo({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          snapshot.data!.about,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10,),
        Text(
          '${snapshot.data!.genre} / ${snapshot.data!.age}',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}