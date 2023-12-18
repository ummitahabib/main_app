import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/pages/socials/screens/social_page.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;

class SocialHomeWidget extends StatelessWidget {
  const SocialHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GetSingleUserProvider>(
          create: (_) => di.locator<GetSingleUserProvider>(),
        ),
      ],
      child: Consumer<GetSingleUserProvider>(
        builder: (context, getSingleUserProvider, child) {
          if (getSingleUserProvider.user != null) {
            return const SocialHomePage();
          } else {
            return Center(
              child: Container(
                child: const Text(
                  errorLoadingData,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
