import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme.dart';

class CaregiverUnlockScreen extends ConsumerWidget {
  const CaregiverUnlockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: const SorgvryLogo(),
      ),
      body: const Center(child: Text('PIN invoer — placeholder')),
    );
  }
}
