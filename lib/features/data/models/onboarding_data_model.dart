//onboarding model
class OnboardingDataModel {
  final String logo;
  final String title;
  final String bgImage;
  final String desc;

  OnboardingDataModel({
    required this.logo,
    required this.title,
    required this.bgImage,
    required this.desc,
  });

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return OnboardingDataModel(
      logo: json['logo'] as String,
      title: json['title'] as String,
      bgImage: json['bgImage'] as String,
      desc: json['desc'] as String,
    );
  }
}
