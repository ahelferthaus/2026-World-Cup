import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/data/demo_data.dart';
import '../../../../core/extensions/async_value_extensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/token_formatter.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/team_flag.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../home/domain/match_model.dart';
import '../../../home/presentation/providers/matches_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/predict_providers.dart';

class PredictionForm extends ConsumerStatefulWidget {
  const PredictionForm({super.key, required this.match});

  final MatchModel match;

  @override
  ConsumerState<PredictionForm> createState() => _PredictionFormState();
}

class _PredictionFormState extends ConsumerState<PredictionForm> {
  String? _selectedOutcome;
  double _wager = 5;
  bool _exactScore = false;
  int _scoreHome = 0;
  int _scoreAway = 0;
  bool _isSubmitting = false;

  double get _multiplier => _exactScore ? 5.0 : 2.0;
  int get _potentialReturn => (_wager * _multiplier).toInt();

  Future<void> _submit() async {
    if (_selectedOutcome == null && !_exactScore) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Prediction'),
        content: Text(
          'Wager ${_wager.toInt()} tokens on '
          '${_exactScore ? "$_scoreHome - $_scoreAway" : _selectedOutcome == "home" ? "${widget.match.homeTeam.name} Win" : _selectedOutcome == "away" ? "${widget.match.awayTeam.name} Win" : "Draw"}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Lock In'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    try {
      if (useDemoData) {
        // In demo mode, simulate a successful prediction
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        final idToken = await ref.read(idTokenProvider.future);
        if (idToken == null) throw Exception('Not authenticated');

        await ref.read(predictionsRepositoryProvider).createPrediction(
              idToken: idToken,
              matchId: widget.match.fixtureId.toString(),
              type: _exactScore ? 'exactScore' : 'winner',
              selection: _exactScore ? 'exactScore' : _selectedOutcome!,
              wager: _wager.toInt(),
              scoreHome: _exactScore ? _scoreHome : null,
              scoreAway: _exactScore ? _scoreAway : null,
            );
      }

      if (mounted) {
        // Refresh data
        ref.invalidate(userProfileProvider);
        ref.invalidate(userPredictionsProvider);
        ref.invalidate(matchesTodayProvider);
        Navigator.pop(context);
        context.showSuccessSnackBar('Prediction locked in!');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).valueOrNull;
    final maxTokens = userProfile?.tokens ?? 0;
    final maxWager = maxTokens.clamp(1, 20).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Match header
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TeamFlag(logoUrl: widget.match.homeTeam.logo, size: 48),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.match.homeTeam.name,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('vs', style: AppTextStyles.heading3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TeamFlag(logoUrl: widget.match.awayTeam.logo, size: 48),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.match.awayTeam.name,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            // Outcome selector
            if (!_exactScore) ...[
              Text('Pick the winner', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _OutcomeChip(
                    label: 'Home',
                    selected: _selectedOutcome == 'home',
                    onTap: () => setState(() => _selectedOutcome = 'home'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _OutcomeChip(
                    label: 'Draw',
                    selected: _selectedOutcome == 'draw',
                    onTap: () => setState(() => _selectedOutcome = 'draw'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _OutcomeChip(
                    label: 'Away',
                    selected: _selectedOutcome == 'away',
                    onTap: () => setState(() => _selectedOutcome = 'away'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            // Exact score toggle
            SwitchListTile(
              title: const Text('Predict exact score (5x payout)'),
              value: _exactScore,
              onChanged: (v) => setState(() {
                _exactScore = v;
                if (v) _selectedOutcome = null;
              }),
              contentPadding: EdgeInsets.zero,
            ),
            if (_exactScore) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ScoreSelector(
                    label: widget.match.homeTeam.name,
                    value: _scoreHome,
                    onChanged: (v) => setState(() => _scoreHome = v),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text('-', style: AppTextStyles.heading2),
                  ),
                  _ScoreSelector(
                    label: widget.match.awayTeam.name,
                    value: _scoreAway,
                    onChanged: (v) => setState(() => _scoreAway = v),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            // Wager slider
            Text(
              'Wager: ${_wager.toInt()} tokens',
              style: AppTextStyles.heading3,
            ),
            Slider(
              value: _wager.clamp(1, maxWager),
              min: 1,
              max: maxWager < 1 ? 1 : maxWager,
              divisions: (maxWager - 1).toInt().clamp(1, 19),
              label: '${_wager.toInt()}',
              onChanged: maxTokens > 0
                  ? (v) => setState(() => _wager = v)
                  : null,
            ),
            Text(
              'Potential return: ${TokenFormatter.format(_potentialReturn)} tokens',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Submit button
            GradientButton(
              label: 'Lock In Prediction',
              onPressed: (_selectedOutcome != null || _exactScore) &&
                      !_isSubmitting &&
                      maxTokens > 0
                  ? _submit
                  : null,
              isLoading: _isSubmitting,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _OutcomeChip extends StatelessWidget {
  const _OutcomeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.textOnPrimary : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreSelector extends StatelessWidget {
  const _ScoreSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 28,
            ),
            Text(
              '$value',
              style: AppTextStyles.heading2,
            ),
            IconButton(
              onPressed: value < 15 ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 28,
            ),
          ],
        ),
      ],
    );
  }
}
