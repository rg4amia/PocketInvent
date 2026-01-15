import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize date formatting for French locale
  // Note: 'fr_FR' in DateFormat maps to 'fr' locale data
  await initializeDateFormatting('fr', null);

  // Initialize Hive
  await Hive.initFlutter();
  await Get.putAsync(() => StorageService().init());

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize SupabaseService (after Supabase is initialized)
  Get.put(SupabaseService());

  // Initialize NotificationService
  Get.put(NotificationService());

  // Initialize SyncService (after StorageService and SupabaseService)
  Get.put(SyncService());

  // Set iOS status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PocketInventApp());
}

class PocketInventApp extends StatelessWidget {
  const PocketInventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PocketInvent',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
