import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

class FollowingPage extends StatelessWidget {
  final UserEntity user;
  const FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Following"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: user.following!.isEmpty
                  ? _noFollowersWidget()
                  : ListView.builder(
                      itemCount: user.following!.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<List<UserEntity>>(
                          stream: di
                              .locator<GetSingleUserUseCase>()
                              .call(user.following![index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData == false) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.data!.isEmpty) {
                              return Container();
                            }
                            final singleUserData = snapshot.data!.first;
                            return GestureDetector(
                              onTap: () {
                                ApplicationHelpers().trackButtonAndDeviceEvent(
                                    'NAVAIGATE_TO_SINGLE_USER_PROFILE');
                                ApplicationHelpers().navigationHelper(
                                  context,
                                  SingleUserProfilePage(
                                    otherUserId: singleUserData.uid!,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: profileWidget(
                                        imageUrl: singleUserData.profileUrl,
                                      ),
                                    ),
                                  ),
                                  customSizedBoxWidth(SpacingConstants.size10),
                                  Text(
                                    "${singleUserData.email}",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Center _noFollowersWidget() {
    return const Center(
      child: Text(
        "No Following",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
