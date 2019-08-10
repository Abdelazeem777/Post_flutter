class User {
  int id;
  String name;
  String email;
  Picture picture;

  User({
    this.id,
    this.name,
    this.email,
    this.picture,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.picture != null) {
      data['picture'] = this.picture.toJson();
    }
    return data;
  }
}

class Picture {
  String large;
  String medium;
  String thumbnail;

  Picture({this.large, this.medium, this.thumbnail});

  Picture.fromJson(Map<String, dynamic> json) {
    large = json['large'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['large'] = this.large;
    data['medium'] = this.medium;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}
