import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class IsSignInUseCase {
  final FirebaseRepository repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() async {
    final isSignedIn = await repository.isSignIn();
    return isSignedIn;
  }
}
