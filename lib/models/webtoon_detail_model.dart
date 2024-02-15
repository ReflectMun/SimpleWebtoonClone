class WebtoonDetailModel {
  final String title, about, genre, age;

  WebtoonDetailModel.fromJson(Map<String, dynamic> json) :
        this.title = json['title'],
        this.about = json['about'],
        this.genre = json['genre'],
        this.age = json['age'];
}