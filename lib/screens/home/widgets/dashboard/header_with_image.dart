import 'package:flutter/material.dart';
import 'package:smat_crow/utils/colors.dart';

class HeaderWithImage extends StatefulWidget {
  final String firstName, lastName, email;

  const HeaderWithImage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeaderWithImageState();
  }
}

class _HeaderWithImageState extends State<HeaderWithImage> {
  String firstName = '', lastName = '', email = '';

  @override
  void initState() {
    super.initState();
    getProfileInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.transparent,
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/nsvgs/dashboard/UserProfile.png',
                width: 37,
                height: 37,
              ),
              const SizedBox(
                width: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Hi, ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'regular',
                          ),
                        ),
                        Text(
                          firstName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'regular',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        color: AppColors.unselectedItemColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'regular',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getProfileInformation() {
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
  }
}
