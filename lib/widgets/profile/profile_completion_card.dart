import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';

class ProfileCompletionCard extends StatefulWidget {
  const ProfileCompletionCard({super.key});
  @override
  State<ProfileCompletionCard> createState() => _ProfileCompletionCardState();
}

class _ProfileCompletionCardState extends State<ProfileCompletionCard> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    _loadVisibility();
  }
  Future<void> _loadVisibility() async {
    final show = await ProfileController.instance.shouldShowCompletionCard();
    if (mounted) setState(() => _visible = show);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProfileState>(
      stream: ProfileController.instance.stream,
      initialData: ProfileController.instance.state,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (!_visible || state?.profile == null || state!.completion >= 1.0) return const SizedBox.shrink();
        final missing = ProfileController.instance.getMissingFields(state.profile);
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Complete profile (${(state.completion * 100).toInt()}%)"),
                  IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () {
                    ProfileController.instance.dismissCompletionCard();
                    setState(() => _visible = false);
                  }),
                ],
              ),
              LinearProgressIndicator(value: state.completion),
              Wrap(spacing: 8, children: missing.map((field) => ActionChip(label: Text(field), onPressed: () {})).toList()),
            ],
          ),
        );
      },
    );
  }
}
