import 'package:bad_fl_doc/pages/boot.dart';
import 'package:bad_fl_doc/pages/helper/debounce.dart';
import 'package:bad_fl_doc/pages/helper/throttle.dart';
import 'package:bad_fl_doc/pages/prefab/otp_input.dart';
import 'package:bad_fl_doc/pages/prefab/password_input.dart';
import 'package:bad_fl_doc/pages/prefab/text_input.dart';
import 'package:bad_fl_doc/routes/name.dart';
import 'package:get/get.dart';

final List<GetPage> route = [
  GetPage(name: NamedRoute.boot, page: () => const BootPage()),

  // helper
  GetPage(name: NamedRoute.debounce, page: () => const DebouncePage()),
  GetPage(name: NamedRoute.throttle, page: () => const ThrottlePage()),

  // prefab
  GetPage(name: NamedRoute.otpInput, page: () => const OTPInputPage()),
  GetPage(name: NamedRoute.textInput, page: () => const TextInputPage()),
  GetPage(
    name: NamedRoute.passwordInput,
    page: () => const PasswordInputPage(),
  ),

  // tobe implemented
];
