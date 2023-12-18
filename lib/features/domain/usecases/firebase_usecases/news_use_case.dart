import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class GetNewsUseCase {
  final FirebaseRepository repository;

  GetNewsUseCase({required this.repository});
  Future<List<NewsEntity>> call(NewsEntity newsEntity) {
    return repository.fetchNews(newsEntity);
  }
}
