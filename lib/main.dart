import 'package:fieldsync/features/sync/data/fake_sync_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/di.dart';
import 'features/sync/domain/sync_status.dart';
import 'features/sync/presentation/bloc/sync_state.dart';
import 'features/sync/presentation/bloc/sync_status_bloc.dart';

void main() {
  setupDi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Sync',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Field Sync Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocProvider(
              create: (context) =>
                  SyncStatusBloc(repository: FakeSyncRepository()),

              child: BlocSelector<SyncStatusBloc, SyncState, SyncStatus>(
                selector: (state) {
                  return state.status;
                },
                builder: (context, status) {
                  return Column(
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('Sync now')),
                      Text('Current status: $status'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
