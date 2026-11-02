import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/lists_provider.dart';
import '../widgets/error_view.dart';
import 'list_details_screen.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});
  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<ListsProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Calley Personal')),
      body: switch (p.state) {
        LoadState.idle || LoadState.loading =>
          const Center(child: CircularProgressIndicator()),
        LoadState.error => ErrorView(message: p.error ?? 'Error', onRetry: p.load),
        LoadState.success => p.lists.isEmpty
            ? const Center(child: Text('No call lists found.'))
            : RefreshIndicator(
                onRefresh: p.load,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: p.lists.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final l = p.lists[i];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: const CircleAvatar(
                            child: Icon(Icons.list_alt_rounded)),
                        title: Text(l.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${l.agents.length} agent(s)'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ListDetailsScreen(list: l)),
                        ),
                      ),
                    );
                  },
                ),
              ),
      },
    );
  }
}
