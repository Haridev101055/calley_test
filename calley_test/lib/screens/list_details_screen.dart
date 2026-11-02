import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/call_contact.dart';
import '../models/call_list.dart';
import '../providers/list_details_provider.dart';
import '../providers/lists_provider.dart';
import '../services/api_service.dart';
import '../widgets/error_view.dart';
import '../widgets/stat_card.dart';

class ListDetailsScreen extends StatelessWidget {
  const ListDetailsScreen({super.key, required this.list});
  final CallList list;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ListDetailsProvider(ctx.read<ApiService>(), list.id)..load(),
      child: _Body(list: list),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.list});
  final CallList list;

  Future<void> _call(BuildContext context, CallContact c) async {
    final messenger = ScaffoldMessenger.of(context);
    if (c.phone == null) {
      messenger.showSnackBar(
          const SnackBar(content: Text('No phone number available.')));
      return;
    }
    final ok = await launchUrl(Uri(scheme: 'tel', path: c.phone));
    if (!ok) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Unable to open dialer.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ListDetailsProvider>();
    final d = p.details;

    return Scaffold(
      appBar: AppBar(title: Text(list.name)),
      body: switch (p.state) {
        LoadState.idle || LoadState.loading =>
          const Center(child: CircularProgressIndicator()),
        LoadState.error => ErrorView(message: p.error ?? 'Error', onRetry: p.load),
        LoadState.success => RefreshIndicator(
            onRefresh: p.load,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(children: [
                      Row(children: [
                        StatCard(
                            label: 'Pending',
                            value: d!.pending,
                            color: Colors.orange,
                            icon: Icons.hourglass_bottom),
                        StatCard(
                            label: 'Called',
                            value: d.called,
                            color: Colors.green,
                            icon: Icons.call_made),
                        StatCard(
                            label: 'Rescheduled',
                            value: d.rescheduled,
                            color: Colors.blue,
                            icon: Icons.event_repeat),
                      ]),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: d.total == 0 ? 0 : d.called / d.total,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${d.called} of ${d.total} contacted',
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (v) => p.query = v,
                        decoration: InputDecoration(
                          hintText: 'Search contacts',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ]),
                  ),
                ),
                if (p.filteredCalls.isEmpty)
                  const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('No contacts found.')))
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    sliver: SliverList.separated(
                      itemCount: p.filteredCalls.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final c = p.filteredCalls[i];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text(c.initials)),
                            title: Text(c.fullName),
                            subtitle: c.phone != null ? Text(c.phone!) : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () => _call(context, c),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
      },
    );
  }
}
