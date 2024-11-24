import 'package:tangullo/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:tangullo/ui/dialogs/info_alert/info_alert_dialog.dart';

import 'package:tangullo/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:tangullo/ui/views/navigation/homepage_view.dart';
import 'package:tangullo/ui/views/dashboard/dashboard_view.dart';
import 'package:tangullo/ui/views/messages/messages_view.dart';
import 'package:tangullo/ui/views/books/books_view.dart';
import 'package:tangullo/ui/views/profile/profile_view.dart';
import 'package:tangullo/ui/views/login/login_view.dart';
import 'package:tangullo/ui/views/signup/signup_view.dart';
import 'package:tangullo/ui/views/splashscreen/splashscreen_view.dart';
import 'package:tangullo/ui/views/therapist/therapist_view.dart';
import 'package:tangullo/ui/views/chatscreen/chatscreen_view.dart';
import 'package:tangullo/ui/views/addfriends/addfriends_view.dart';
import 'package:tangullo/ui/views/meditation/meditation_view.dart';
import 'package:tangullo/ui/views/settings/settings_view.dart';

import 'package:tangullo/ui/views/journalizing/journalizing_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomepageView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: MessagesView),
    MaterialRoute(page: BooksView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: SplashscreenView),
    MaterialRoute(page: TherapistView),
    MaterialRoute(page: ChatscreenView),
    MaterialRoute(page: AddfriendsView),
    MaterialRoute(page: MeditationView),
    MaterialRoute(page: SettingsView),

    MaterialRoute(page: JournalizingView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
