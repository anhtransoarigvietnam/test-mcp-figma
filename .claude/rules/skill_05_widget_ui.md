---
description: Flutter widget ui skill
paths:
-e   - **/*_test.dart
  - **/test/**
---
Summary: Page structure, DI injection per screen, and BlocListener/BlocBuilder usage.

# UI and Widget Structure

Screens are isolated in `lib/presentation/screen/`. Each feature usually contains:
- `feature_page.dart`: The root wrapper handling DI.
- `feature_navigator.dart`: The navigation helper.
- `widget/feature_view_content.dart`: The actual stateful/stateless UI.
- `view_model/`: Cubit and State files.

## 1. Page Wrapper (DI Setup)
The `Page` widget sets up providers before rendering the content.

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeViewModel>(
          create: (_) => GetIt.instance<HomeViewModel>(),
        ),
        RepositoryProvider<HomeNavigator>(
          create: (_) => GetIt.instance<HomeNavigator>(),
        ),
      ],
      child: const HomeViewContent(),
    );
  }
}
```

## 2. View Content (UI)
The `ViewContent` handles the layout, lifecycle (`initState`), and reacts to the Cubit.

**BlocListener for side effects:**
```dart
BlocListener<HomeViewModel, HomeState>(
  listenWhen: (previous, current) => previous.advertisement != current.advertisement,
  listener: (context, state) {
    // Show dialogs, snackbars, or navigate
    DialogUtility.showAdvertisementDialog(context: context, advertisement: state.advertisement!);
  },
  child: Scaffold(...)
)
```

**Accessing ViewModel/Navigator:**
```dart
// To trigger actions
context.read<HomeViewModel>().fetchCollectionSummary();

// To navigate
context.read<HomeNavigator>().goToSetting();
```

## 3. Widget Splitting
Large screens must be split into smaller sections placed inside the `widget/` folder (e.g., `home_header_section.dart`, `home_scan_button_section.dart`). Use `BlocBuilder` locally in those sections when possible, rather than rebuilding the whole screen.
