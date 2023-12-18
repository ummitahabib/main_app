import 'package:flutter/material.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:smat_crow/features/presentation/pages/profile/single_user_profile_page.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

class FollowersPage extends StatelessWidget {
  final UserEntity user;
  const FollowersPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Followers"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: user.followers!.isEmpty
                  ? _noFollowersWidget()
                  : ListView.builder(
                      itemCount: user.followers!.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<List<UserEntity>>(
                          stream: di
                              .locator<GetSingleUserUseCase>()
                              .call(user.followers![index]),
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
                                    width: SpacingConstants.size32,
                                    height: SpacingConstants.size32,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        SpacingConstants.size32,
                                      ),
                                      child: profileWidget(
                                        imageUrl: singleUserData.profileUrl,
                                      ),
                                    ),
                                  ),
                                  customSizedBoxWidth(SpacingConstants.size10),
                                  Column(
                                    children: [
                                      Text(
                                        "${singleUserData.firstName} $emptyString ${singleUserData.lastName}",
                                        style: const TextStyle(
                                          color: Color(0xFF111A27),
                                          fontFamily: 'Basier Circle',
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          height: 1.6,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                      Text(
                                        "${singleUserData.email}",
                                        style: const TextStyle(
                                          color: Color(0xFF6B7380),
                                          fontFamily: 'Basier Circle',
                                          fontSize: 10.0,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          height: 1.6,
                                          letterSpacing: -0.1,
                                        ),
                                      )
                                    ],
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
        noFollowersText,
        style: TextStyle(
          color: AppColors.SmatCrowNeuBlue800,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
