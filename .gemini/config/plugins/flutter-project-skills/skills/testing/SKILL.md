---
name: "testing"
description: "Standard flutter_test widget testing."
---
Summary: Standard flutter_test widget testing.

# Testing

Tests are located in the root `test/` directory.

## Widget Tests
Currently, standard widget testing is used via `flutter_test`. 

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('0'), findsOneWidget);
  });
}
```

*(Note: During analysis, only a basic `widget_test.dart` was found. More comprehensive Bloc and unit testing conventions have not yet been heavily populated in this repository.)*
