import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


extension LocalStrings on BuildContext {

  AppLocalizations get strings {
    return AppLocalizations.of(this)!;
  }
}