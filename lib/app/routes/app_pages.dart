import 'package:get/get.dart';

import '../modules/completed/bindings/completed_binding.dart';
import '../modules/completed/views/completed_view.dart';
import '../modules/grid-order/bindings/grid_order_binding.dart';
import '../modules/grid-order/views/grid_order_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/more/bindings/more_binding.dart';
import '../modules/more/views/more_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/ticker-edit/bindings/ticker_edit_binding.dart';
import '../modules/ticker-edit/views/ticker_edit_view.dart';
import '../modules/tickers/bindings/tickers_binding.dart';
import '../modules/tickers/views/tickers_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.COMPLETED,
      page: () => const CompletedView(),
      binding: CompletedBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.GRID_ORDER,
      page: () => const GridOrderView(),
      binding: GridOrderBinding(),
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => const MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: _Paths.TICKERS,
      page: () => const TickersView(),
      binding: TickersBinding(),
    ),
    GetPage(
      name: _Paths.TICKER_EDIT,
      page: () => const TickerEditView(),
      binding: TickerEditBinding(),
    ),
  ];
}
