import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_mcp_figma/presentation/screen/home/home_navigator.dart';
import 'package:test_mcp_figma/presentation/screen/home/widget/home_view_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => GetIt.I<HomeNavigator>(),
      child: const HomeViewContent(),
    );
  }
}