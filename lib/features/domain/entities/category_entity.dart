import 'package:equatable/equatable.dart';
import 'package:smat_crow/utils2/constants.dart';

class CategoryEntity extends Equatable {
  final String? name;
  final String? imageUrl;

  const CategoryEntity({
    this.name,
    this.imageUrl,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      name: json[Category.name],
      imageUrl: json[Category.imageUrl],
    );
  }

  @override
  List<Object?> get props => [
        name,
        imageUrl,
      ];
}

List<CategoryEntity> categories = [
  const CategoryEntity(name: topStories, imageUrl: agriculture),
  const CategoryEntity(name: nigeriaName, imageUrl: nigeria),
  const CategoryEntity(name: africaName, imageUrl: africa),
  const CategoryEntity(name: northAmericaName, imageUrl: northAmerica),
  const CategoryEntity(name: southAmericaName, imageUrl: southAmerica),
  const CategoryEntity(name: europeName, imageUrl: europe),
  const CategoryEntity(name: middleEastName, imageUrl: middleEast),
  const CategoryEntity(name: asiaName, imageUrl: asia),
  const CategoryEntity(name: australiaName, imageUrl: australia),
];
