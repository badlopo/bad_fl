import 'package:bad_fl_doc/pages/_misc.dart';
import 'package:bad_fl_doc/pages/boot.dart';
import 'package:bad_fl_doc/pages/otp_input.dart';
import 'package:bad_fl_doc/pages/password_input.dart';
import 'package:bad_fl_doc/pages/text_input.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.boot, page: () => const BootPage()),
  GetPage(
    name: NamedRoute.misc,
    transition: Transition.noTransition,
    page: () => const MiscPage(),
  ),
  GetPage(name: NamedRoute.otpInput, page: () => const OTPInputPage()),
  GetPage(
    name: NamedRoute.passwordInput,
    page: () => const PasswordInputPage(),
  ),
  GetPage(name: NamedRoute.textInput, page: () => const TextInputPage()),
];
