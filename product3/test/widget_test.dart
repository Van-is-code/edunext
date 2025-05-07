import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product3/main.dart';
import 'package:product3/product_list_page.dart';

void main() {
  testWidgets('Test ProductListPage widget', (WidgetTester tester) async {
    // Build the MaterialApp with ProductListPage as the home widget
    await tester.pumpWidget(MaterialApp(
      home: ProductListPage(),
    ));

    // Verify that the ProductListPage is displayed
    expect(find.byType(ProductListPage), findsOneWidget);
  });
}