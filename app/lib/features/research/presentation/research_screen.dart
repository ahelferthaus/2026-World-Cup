import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/widgets/animated_background.dart';
import '../../../core/widgets/glassmorphic_card.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({super.key});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _loading = false;
  String? _result;
  List<String> _citations = [];
  String? _error;

  static const _suggestions = [
    'Mbappe World Cup stats',
    'USA 2026 World Cup squad predictions',
    'Who are the favorites to win the 2026 World Cup?',
    'Lionel Messi international career stats',
    'Best World Cup goals of all time',
    'England vs Germany head-to-head record',
  ];

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _result = null;
      _citations = [];
      _error = null;
    });

    if (useDemoData) {
      // Simulate a research response in demo mode
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _loading = false;
        _result = DemoData.researchResult(query);
        _citations = [
          'https://www.fifa.com',
          'https://www.espn.com/soccer',
          'https://www.transfermarkt.com',
        ];
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://us-central1-YOUR_PROJECT.cloudfunctions.net/research'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query.trim()}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _loading = false;
          _result = data['content'] as String? ?? '';
          _citations = List<String>.from(data['citations'] ?? []);
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'Research failed. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Could not connect to research service.';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: [
        AppColors.neonCyan.withValues(alpha: 0.15),
        AppColors.primary.withValues(alpha: 0.2),
        AppColors.neonPurple.withValues(alpha: 0.1),
      ],
      orbCount: 2,
      speed: 0.4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppColors.background.withValues(alpha: 0.85),
          title: Row(
            children: [
              Icon(Icons.science, color: AppColors.neonCyan, size: 22),
              const SizedBox(width: AppSpacing.sm),
              const Text('Research Lab'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Ask about any player, team, or match...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.neonCyan),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                          borderSide: const BorderSide(color: AppColors.neonCyan, width: 2),
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: _search,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.neonCyan, AppColors.primary]),
                      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _search(_controller.text),
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: _loading
                  ? _buildLoading()
                  : _error != null
                      ? _buildError()
                      : _result != null
                          ? _buildResult()
                          : _buildSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppColors.tokenGold),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'QUICK SEARCHES',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _suggestions.map((s) {
              return GlassmorphicCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                onTap: () {
                  _controller.text = s;
                  _search(s);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, size: 14, color: AppColors.neonCyan),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      s,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Column(
              children: [
                Icon(Icons.science, size: 64, color: AppColors.neonCyan.withValues(alpha: 0.3)),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Powered by Perplexity AI',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Get real-time football research with sources',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.neonCyan),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Researching...',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: GlassmorphicCard(
        margin: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.lost),
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => _search(_controller.text),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result card
          GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: AppColors.neonCyan),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'RESEARCH RESULTS',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.neonCyan,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Render markdown-style content as styled text
                _MarkdownBody(content: _result!),
              ],
            ),
          ),

          // Citations
          if (_citations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              'SOURCES',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _citations.take(4).map((url) {
                final domain = Uri.tryParse(url)?.host ?? url;
                return GlassmorphicCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, size: 12, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        domain,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // New search button
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _result = null;
                  _citations = [];
                  _controller.clear();
                });
              },
              icon: const Icon(Icons.search),
              label: const Text('New Search'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple markdown-like text renderer (handles **bold**, headers, lists).
class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: AppSpacing.sm));
        continue;
      }

      if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Text(
            line.substring(4),
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.neonCyan),
          ),
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: Text(
            line.substring(3),
            style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
          ),
        ));
      } else if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: AppSpacing.md),
          child: Text(
            line.substring(2),
            style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary),
          ),
        ));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md, top: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('  \u2022  ', style: TextStyle(color: AppColors.neonCyan, fontSize: 14)),
              Expanded(
                child: _RichLine(text: line.substring(2)),
              ),
            ],
          ),
        ));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 2),
          child: _RichLine(text: line),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

/// Renders inline **bold** text.
class _RichLine extends StatelessWidget {
  const _RichLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}
