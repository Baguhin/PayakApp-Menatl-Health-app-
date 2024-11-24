// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i17;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i18;
import 'package:tangullo/ui/views/addfriends/addfriends_view.dart' as _i13;
import 'package:tangullo/ui/views/books/books_view.dart' as _i6;
import 'package:tangullo/ui/views/chatscreen/chatscreen_view.dart' as _i12;
import 'package:tangullo/ui/views/dashboard/dashboard_view.dart' as _i4;
import 'package:tangullo/ui/views/journalizing/journalizing_view.dart' as _i16;
import 'package:tangullo/ui/views/login/login_view.dart' as _i8;
import 'package:tangullo/ui/views/meditation/meditation_view.dart' as _i14;
import 'package:tangullo/ui/views/messages/messages_view.dart' as _i5;
import 'package:tangullo/ui/views/navigation/homepage_view.dart' as _i3;
import 'package:tangullo/ui/views/profile/profile_view.dart' as _i7;
import 'package:tangullo/ui/views/settings/settings_view.dart' as _i15;
import 'package:tangullo/ui/views/signup/signup_view.dart' as _i9;
import 'package:tangullo/ui/views/splashscreen/splashscreen_view.dart' as _i10;
import 'package:tangullo/ui/views/startup/startup_view.dart' as _i2;
import 'package:tangullo/ui/views/therapist/therapist_view.dart' as _i11;

class Routes {
  static const startupView = '/startup-view';

  static const homepageView = '/homepage-view';

  static const dashboardView = '/dashboard-view';

  static const messagesView = '/messages-view';

  static const booksView = '/books-view';

  static const profileView = '/profile-view';

  static const loginView = '/login-view';

  static const signupView = '/signup-view';

  static const splashscreenView = '/splashscreen-view';

  static const therapistView = '/therapist-view';

  static const chatscreenView = '/chatscreen-view';

  static const addfriendsView = '/addfriends-view';

  static const meditationView = '/meditation-view';

  static const settingsView = '/settings-view';

  static const journalizingView = '/journalizing-view';

  static const all = <String>{
    startupView,
    homepageView,
    dashboardView,
    messagesView,
    booksView,
    profileView,
    loginView,
    signupView,
    splashscreenView,
    therapistView,
    chatscreenView,
    addfriendsView,
    meditationView,
    settingsView,
    journalizingView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.homepageView,
      page: _i3.HomepageView,
    ),
    _i1.RouteDef(
      Routes.dashboardView,
      page: _i4.DashboardView,
    ),
    _i1.RouteDef(
      Routes.messagesView,
      page: _i5.MessagesView,
    ),
    _i1.RouteDef(
      Routes.booksView,
      page: _i6.BooksView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i8.LoginView,
    ),
    _i1.RouteDef(
      Routes.signupView,
      page: _i9.SignupView,
    ),
    _i1.RouteDef(
      Routes.splashscreenView,
      page: _i10.SplashscreenView,
    ),
    _i1.RouteDef(
      Routes.therapistView,
      page: _i11.TherapistView,
    ),
    _i1.RouteDef(
      Routes.chatscreenView,
      page: _i12.ChatscreenView,
    ),
    _i1.RouteDef(
      Routes.addfriendsView,
      page: _i13.AddfriendsView,
    ),
    _i1.RouteDef(
      Routes.meditationView,
      page: _i14.MeditationView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i15.SettingsView,
    ),
    _i1.RouteDef(
      Routes.journalizingView,
      page: _i16.JournalizingView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.HomepageView: (data) {
      final args = data.getArgs<HomepageViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i3.HomepageView(key: args.key, title: args.title),
        settings: data,
      );
    },
    _i4.DashboardView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.DashboardView(),
        settings: data,
      );
    },
    _i5.MessagesView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.MessagesView(),
        settings: data,
      );
    },
    _i6.BooksView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.BooksView(),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.ProfileView(),
        settings: data,
      );
    },
    _i8.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.LoginView(key: args.key, title: args.title),
        settings: data,
      );
    },
    _i9.SignupView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.SignupView(),
        settings: data,
      );
    },
    _i10.SplashscreenView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.SplashscreenView(),
        settings: data,
      );
    },
    _i11.TherapistView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.TherapistView(),
        settings: data,
      );
    },
    _i12.ChatscreenView: (data) {
      final args = data.getArgs<ChatscreenViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.ChatscreenView(
            chatId: args.chatId, userName: args.userName, key: args.key),
        settings: data,
      );
    },
    _i13.AddfriendsView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.AddfriendsView(),
        settings: data,
      );
    },
    _i14.MeditationView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.MeditationView(),
        settings: data,
      );
    },
    _i15.SettingsView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.SettingsView(),
        settings: data,
      );
    },
    _i16.JournalizingView: (data) {
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.JournalizingView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomepageViewArguments {
  const HomepageViewArguments({
    this.key,
    required this.title,
  });

  final _i17.Key? key;

  final String title;

  @override
  String toString() {
    return '{"key": "$key", "title": "$title"}';
  }

  @override
  bool operator ==(covariant HomepageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.title == title;
  }

  @override
  int get hashCode {
    return key.hashCode ^ title.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({
    this.key,
    required this.title,
  });

  final _i17.Key? key;

  final String title;

  @override
  String toString() {
    return '{"key": "$key", "title": "$title"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.title == title;
  }

  @override
  int get hashCode {
    return key.hashCode ^ title.hashCode;
  }
}

class ChatscreenViewArguments {
  const ChatscreenViewArguments({
    required this.chatId,
    required this.userName,
    this.key,
  });

  final String chatId;

  final String userName;

  final _i17.Key? key;

  @override
  String toString() {
    return '{"chatId": "$chatId", "userName": "$userName", "key": "$key"}';
  }

  @override
  bool operator ==(covariant ChatscreenViewArguments other) {
    if (identical(this, other)) return true;
    return other.chatId == chatId &&
        other.userName == userName &&
        other.key == key;
  }

  @override
  int get hashCode {
    return chatId.hashCode ^ userName.hashCode ^ key.hashCode;
  }
}

extension NavigatorStateExtension on _i18.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomepageView({
    _i17.Key? key,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homepageView,
        arguments: HomepageViewArguments(key: key, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMessagesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.messagesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBooksView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.booksView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i17.Key? key,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSplashscreenView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.splashscreenView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTherapistView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.therapistView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChatscreenView({
    required String chatId,
    required String userName,
    _i17.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.chatscreenView,
        arguments: ChatscreenViewArguments(
            chatId: chatId, userName: userName, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddfriendsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addfriendsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMeditationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.meditationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToJournalizingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.journalizingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomepageView({
    _i17.Key? key,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homepageView,
        arguments: HomepageViewArguments(key: key, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithDashboardView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.dashboardView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMessagesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.messagesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBooksView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.booksView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i17.Key? key,
    required String title,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key, title: title),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSplashscreenView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.splashscreenView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTherapistView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.therapistView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChatscreenView({
    required String chatId,
    required String userName,
    _i17.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.chatscreenView,
        arguments: ChatscreenViewArguments(
            chatId: chatId, userName: userName, key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddfriendsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addfriendsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMeditationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.meditationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithJournalizingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.journalizingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
