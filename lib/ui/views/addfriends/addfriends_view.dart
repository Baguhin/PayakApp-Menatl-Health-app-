import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'addfriends_viewmodel.dart';

class AddfriendsView extends StackedView<AddfriendsViewModel> {
  const AddfriendsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddfriendsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 26, 226, 193),
        toolbarHeight: 40.0, // Adjust the height of the AppBar as needed
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('yawa'),
      ),
    );
  }

  @override
  AddfriendsViewModel viewModelBuilder(BuildContext context) =>
      AddfriendsViewModel();
}
