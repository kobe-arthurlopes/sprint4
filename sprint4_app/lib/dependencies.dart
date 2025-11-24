import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/supabase_service.dart';
import 'package:sprint4_app/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/data/repositories/home_repository.dart';
import 'package:sprint4_app/data/repositories/list_repository.dart';
import 'package:sprint4_app/presentation/home/home_view_model.dart';
import 'package:sprint4_app/presentation/content/list_view_model.dart';
import 'package:sprint4_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> injectDependencies() async {

    await Supabase.initialize(
    url: 'https://xrelnsmrfjvyiamzpsbp.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyZWxuc21yZmp2eWlhbXpwc2JwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjI1MTQsImV4cCI6MjA3ODk5ODUxNH0.TOXF9JREDosuSi-Dn34ptk0RWe-y9lNcfZ_8dONW95s'
  );

  final supabaseService = SupabaseService();
  // await supabaseService.authenticate();
  final remoteDataSource = RemoteDataSource(supabaseService: supabaseService);
  final homeRepository = HomeRepository(remote: remoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        Provider<RemoteDataSource>(create: (context) => RemoteDataSource(supabaseService: supabaseService)),
        Provider<HomeRepository>(create: (context) => HomeRepository(remote: context.read())),
        ListenableProvider<ListRepository>(create: (context) => ListRepository(remote: context.read())),
        ChangeNotifierProvider<HomeRepository>(
          create: (context) => HomeRepository(remote: context.read()),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(repository: context.read()),
                ),
        ChangeNotifierProvider<ListViewModel>(
          create: (context) => ListViewModel(repository: context.read())
        )
              ],
    child: const MyApp(),
    )
  );
}

