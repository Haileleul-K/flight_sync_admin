import 'dart:io';

import 'package:flight_sync_admin/core/styles/colors_theme.dart';
import 'package:flight_sync_admin/features/air_craft/bloc/aircraft_bloc.dart';
import 'package:flight_sync_admin/features/auth/login_bloc/login_bloc.dart';
import 'package:flight_sync_admin/features/auth/login_page.dart';
import 'package:flight_sync_admin/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flight_sync_admin/features/dashboard/bloc/dashboard_event.dart';
import 'package:flight_sync_admin/features/duty_position/bloc/duty_position_bloc.dart';
import 'package:flight_sync_admin/features/fac_level/bloc/fac_level_bloc.dart';
import 'package:flight_sync_admin/features/mission/bloc/mission_bloc.dart';
import 'package:flight_sync_admin/features/rank/bloc/rank_bloc.dart';
import 'package:flight_sync_admin/features/rl_level/bloc/rl_level_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/dashboard/layout/app_layout.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() {
  //HttpOverrides.global = MyHttpOverrides();
  configLoading();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = ColorThemes.inputGreyColor
    ..backgroundColor = ColorThemes.primaryColor
    ..indicatorColor = ColorThemes.inputGreyColor
    ..textColor = ColorThemes.inputGreyColor
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(
          430,
          932,
        ),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LoginBloc(),
              ),
              BlocProvider(
                  create: (_) => DashboardBloc()..add(LoadDashboardData())),
              BlocProvider(
                  create: (_) => AircraftBloc()..add(FetchAircraftModels())),
              BlocProvider(
                  create: (_) => DutyPositionBloc()..add(FetchDutyPositions())),
              BlocProvider(
                  create: (_) => RankBloc()..add(FetchRanks())),
              BlocProvider(
                  create: (_) => FacLevelBloc()..add(FetchFacLevels())),
              BlocProvider(
                  create: (_) => RlLevelBloc()..add(FetchRlLevels())),
              BlocProvider(create: (_) => MissionBloc()..add(FetchMissions())),
            ],
            child: GetMaterialApp(
              locale: const Locale('en', 'US'),
              fallbackLocale: const Locale('en', 'US'),
              localizationsDelegates: const [
                DefaultMaterialLocalizations.delegate,
                DefaultWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
              ],
              title: 'FlightSync',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    primary: ColorThemes.primaryColor,
                    background: ColorThemes.backgroundColor,
                    seedColor: ColorThemes.primaryColor),
                useMaterial3: false,
                fontFamily: 'Poppins',
                textTheme: TextTheme(
                  displayLarge: TextStyle(
                    fontSize: 62.sp,
                    color: ColorThemes.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  displayMedium: TextStyle(
                    fontSize: 42.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  titleLarge: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  titleMedium: TextStyle(
                    fontSize: 20.sp,
                    color: ColorThemes.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  labelMedium: TextStyle(
                    fontSize: 14.sp,
                    color: ColorThemes.primaryColor,
                  ),
                  labelSmall: TextStyle(
                    fontSize: 12.sp,
                    color: ColorThemes.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 14.sp,
                    color: ColorThemes.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 12.sp,
                    color: ColorThemes.secondaryColor.withOpacity(0.4),
                  ),
                  bodySmall: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.white,
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: ColorThemes.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0.25,
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    )),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                          fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    // borderSide: const BorderSide(color: ColorThemes.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    // borderSide: const BorderSide(color: ColorThemes.primaryColor),
                  ),
                  hintStyle: TextStyle(
                    color: ColorThemes.greyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                cardTheme: CardThemeData(
                  elevation: 3,
                  shadowColor: ColorThemes.secondaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: ColorThemes.primaryColor.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  color: Colors.white,
                ),
                dividerTheme: DividerThemeData(
                  color: ColorThemes.secondaryColor.withOpacity(0.7),
                  thickness: 0.5,
                ),
              ),
              home:  LoginPage(),
              builder: EasyLoading.init(),
            ),
          );
        });
  }
}
