import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/data/repositories/home_repository.dart';
import 'package:sprint4_app/presentation/home/home_page.dart';
import 'package:sprint4_app/presentation/content/list_page.dart';
import 'package:sprint4_app/presentation/home/home_view_model.dart';
import 'package:sprint4_app/presentation/content/list_view_model.dart';

// Configuração do GoRouter
GoRouter router(HomeRepository homeRepo) {
  return GoRouter(
    initialLocation: '/',
    routes: [
    GoRoute(
          path: '/',
          builder: (context, state) => HomePage(viewModel: HomeViewModel(repository: context.read()))
      ),
    GoRoute(
      path: '/list',
      builder: (context, state) => ListPage(viewModel: ListViewModel(repository: context.read()),)
     )
    ]
  );
}