class OnboardingModel {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  OnboardingModel({this.id, this.title, this.description, this.imageUrl});

  OnboardingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
