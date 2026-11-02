import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'providers/lists_provider.dart';
import 'screens/lists_screen.dart';
import 'services/api_service.dart';

void main() => runApp(const CalleyApp());

class CalleyApp extends StatelessWidget {
  const CalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(
            create: (ctx) => ListsProvider(ctx.read<ApiService>())),
      ],
      child: MaterialApp(
        title: 'Calley Personal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const ListsScreen(),
      ),
    );
  }
}
