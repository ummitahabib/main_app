import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/data/model/language_model.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

Future<void> showLanguageMenu({
  required BuildContext context,
  required List<LanguageModel> languages,
  required Function(LanguageModel language) onSelectLanguage,
}) async {
  final result = await showMenu<LanguageModel>(
    context: context,
    position: RelativeRect.fromLTRB(
     SpacingConstants.size50,
      MediaQuery.of(context).size.height - SpacingConstants.size100,
      MediaQuery.of(context).size.width - SpacingConstants.size50,
      0,
    ), // Size of the button
    // Offset.zero & overlay.size,

    items: languages.map((LanguageModel language) {
      return PopupMenuItem<LanguageModel>(
        value: language,
        child: Text(language.languageName ?? ""),
      );
    }).toList(),
  );

  if (result != null) {
    onSelectLanguage(result);
  }
}
