import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_mcp_figma/presentation/common/widget/common_button.dart';
import 'package:test_mcp_figma/presentation/screen/home/home_navigator.dart';
import 'package:test_mcp_figma/presentation/theme/app_text_palette.dart';
import 'package:test_mcp_figma/utility/extension/build_context.dart';

class HomeViewContent extends StatelessWidget {
  const HomeViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(context.l10n.home_title, style: AppTextPalette.outfit10Bold,),
          const SizedBox(height: 40,),
          CommonButton.filled(
            text: 'Go To Setting',
            onPressed: () => context.read<HomeNavigator>().goToSetting(),
          )
        ],
      ),
    );
  }
}