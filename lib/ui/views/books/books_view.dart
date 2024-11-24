import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'books_viewmodel.dart';

class BooksView extends StackedView<BooksViewModel> {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BooksViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  BooksViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BooksViewModel();
}
