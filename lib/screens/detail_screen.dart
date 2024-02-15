import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_card.dart';

import '../models/webtoon_detail_model.dart';
import '../models/webtoon_episodes_model.dart';
import '../widgets/webtoon_Info.dart';
import '../widgets/webtoon_episode.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> detailInfo;
  late Future<List<WebtoonEpisodesModel>> episodes;
  late SharedPreferences pref;
  bool isLiked = false;

  Future<void> initPrefs() async {
    pref = await SharedPreferences.getInstance();
    final likedToons = pref.getStringList("likedToons");
    if(likedToons != null){
      if(likedToons.contains(widget.id) == true){
        setState(() {
          isLiked = true;
        });
      }
    } else {
      pref.setStringList("likedToons", []);
    }
  }

  @override
  void initState() {
    super.initState();
    detailInfo = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = pref.getStringList("likedToons");
    if(likedToons != null){
      if(isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }

      await pref.setStringList("likedToons", likedToons);
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline_rounded,
            )
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: WebtoonCard(thumb: widget.thumb,)
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: detailInfo,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return WebtoonInfo(snapshot: snapshot,);
                  }
                  return const Text("...");
                }
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (final episode in snapshot.data!)
                          WebtoonEpisode(
                            episode: episode,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator(),);
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}


