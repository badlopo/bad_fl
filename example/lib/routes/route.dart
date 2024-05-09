import 'package:bad_fl_example/pages/_misc.dart';
import 'package:bad_fl_example/pages/boot.dart';
import 'package:bad_fl_example/pages/otp_input.dart';
import 'package:bad_fl_example/pages/password_input.dart';
import 'package:bad_fl_example/pages/text_input.dart';
import 'package:bad_fl_example/routes/name.dart';
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
