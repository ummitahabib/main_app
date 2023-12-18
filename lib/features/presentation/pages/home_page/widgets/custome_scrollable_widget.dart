import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ScrollableWidget extends StatefulWidget {
  const ScrollableWidget({Key? key}) : super(key: key);

  @override
  _ScrollableWidgetState createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<ScrollableWidget> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = SpacingConstants.double0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTopOrBottom() {
    if (_scrollPosition == SpacingConstants.int0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        SpacingConstants.double0,
        duration: const Duration(milliseconds: SpacingConstants.int180),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _scrollToTopOrBottom,
      child: ListView(
        controller: _scrollController,
        children: [
          Column(
            children: [
              const SizedBox(height: SpacingConstants.size1100),
              IgnorePointer(
                ignoring: false,
                child: Container(
                  width: SpacingConstants.size30,
                  height: SpacingConstants.size30,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        SpacingConstants.int150,
                        SpacingConstants.int150,
                        SpacingConstants.int150,
                        SpacingConstants.int75),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    EvaIcons.arrowCircleUpOutline,
                    color: AppColors.SmatCrowDefaultWhite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
