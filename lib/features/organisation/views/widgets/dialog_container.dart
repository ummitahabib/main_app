import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class DialogContainer extends StatelessWidget {
  const DialogContainer({super.key, required this.child, this.height});
  final Widget child;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: kIsWeb
              ? BorderRadius.circular(24)
              : const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(SpacingConstants.size24),
                ),
        ),
        child: child,
      ),
    );
  }
}
