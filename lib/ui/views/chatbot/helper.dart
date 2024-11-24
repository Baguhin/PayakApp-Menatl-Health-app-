import 'package:tangullo/ui/views/chatbot/costant.dart' as constant;
import 'package:flutter/material.dart';

/// Returns a [SizedBox] widget with a specified height.
///
/// The [height] parameter is required and specifies the height of the [SizedBox] widget.
///
/// Example usage:
///
/// ```dart
/// addVerticalSpace(20),
/// ```
Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

/// Returns a [SizedBox] widget with a specified width.
///
/// The [width] parameter is required and specifies the width of the [SizedBox] widget.
///
/// Example usage:
///
/// ```dart
/// addHorizontalSpace(20),
/// ```
Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

/// Displays a custom dialog with the given [widget] as its child.
/// Returns a [Future] that resolves to the value (if any) that was passed to [Navigator.pop] when the dialog was closed.
Future<dynamic> customDialog(
    {required BuildContext context,
    required Widget widget,
    insetPadding = constant.appPadding}) {
  // Use alias for `appPadding`
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: EdgeInsets.all(insetPadding),
          child: Container(child: widget),
        );
      });
}

Widget loadingWidget() {
  return const Center(
    child: RefreshProgressIndicator(),
  );
}
