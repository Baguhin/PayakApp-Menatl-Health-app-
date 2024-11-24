import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/chatbot/metal.dart';
import 'package:tangullo/ui/views/home/home.dart';
import 'package:tangullo/ui/views/messages/messages_view.dart';
import 'package:tangullo/ui/views/settings/settings_view.dart';
import 'package:tangullo/ui/views/therapist/doctor_page.dart';
import 'homepage_viewmodel.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class HomepageView extends StackedView<HomepageViewModel> {
  final String title;

  const HomepageView({Key? key, required this.title}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomepageViewModel viewModel,
    Widget? child,
  ) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Slide Transition for all tabs
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(
              viewModel.currentTabIndex), // Trigger rebuild on tab change
          index: viewModel.currentTabIndex,
          children: <Widget>[
            _buildPageWithShimmer(
                viewModel.isLoading, const Home(userName: '')),
            _buildPageWithShimmer(viewModel.isLoading, const DoctorPage()),
            _buildPageWithShimmer(viewModel.isLoading, const MessagesView()),
            _buildPageWithShimmer(viewModel.isLoading, const SettingsView()),
          ],
        ),
      ),
      floatingActionButton: viewModel.currentTabIndex != 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  _createPageRoute(FlutterGeminiChat(
                    chatContext: '',
                    chatList: const [],
                    apiKey: '',
                  )),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: SizedBox(
                width: screenWidth * 0.2,
                height: screenWidth * 0.2,
                child: Lottie.asset(
                  'assets/loading/chatbot.json',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : null,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(0, 3, 3, 3),
        color: color.primary,
        onTap: (index) {
          viewModel.onTabSelected(index);
        },
        animationDuration: const Duration(milliseconds: 400),
        height: screenHeight * 0.08,
        items: <Widget>[
          Icon(Icons.spa, size: screenWidth * 0.07, color: Colors.white),
          Icon(Icons.people, size: screenWidth * 0.07, color: Colors.white),
          Icon(Icons.chat, size: screenWidth * 0.07, color: Colors.white),
          Icon(Icons.settings, size: screenWidth * 0.07, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildPageWithShimmer(bool isLoading, Widget child) {
    // Show shimmer effect when loading is true, otherwise show the actual page content
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: child,
          )
        : child;
  }

  // Create a custom page route with a transition
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Custom transition: Slide from the right
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration:
          const Duration(milliseconds: 500), // Set transition duration
    );
  }

  @override
  HomepageViewModel viewModelBuilder(BuildContext context) =>
      HomepageViewModel();
}
