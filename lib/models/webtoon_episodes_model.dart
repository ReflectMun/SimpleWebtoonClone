class WebtoonEpisodesModel{
  final String id, title, rating, date;

  WebtoonEpisodesModel.fromJson(Map<String, dynamic> json) :
        this.id = json['id'],
        this.title = json['title'],
        this.rating = json['rating'],
        this.date = json['date'];
}