import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/glassmorphic_card.dart';

/// Supper Club / Party Mode lobby for group betting.
class PartyModeLobby extends StatefulWidget {
  const PartyModeLobby({super.key});

  @override
  State<PartyModeLobby> createState() => _PartyModeLobbyState();
}

class _PartyModeLobbyState extends State<PartyModeLobby> {
  bool _inRoom = false;
  String? _roomCode;

  static const _demoParticipants = [
    {'name': 'You', 'emoji': '\u{1F60E}'},
    {'name': 'SoccerKing99', 'emoji': '\u{26BD}'},
    {'name': 'BucketBoss', 'emoji': '\u{1F3C0}'},
    {'name': 'PredictPro', 'emoji': '\u{1F52E}'},
  ];

  static const _demoRoomBets = [
    {'title': 'Who wins the next round of charades?', 'wager': 10, 'picks': 3},
    {'title': 'Best poker face — group votes', 'wager': 15, 'picks': 4},
    {'title': 'First person to laugh loses', 'wager': 5, 'picks': 2},
  ];

  void _createRoom() {
    final code = List.generate(
        6, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[Random().nextInt(36)])
        .join();
    setState(() {
      _inRoom = true;
      _roomCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_inRoom) return _buildLobby(context);
    return _buildRoom(context);
  }

  Widget _buildLobby(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('\u{1F3B2}', style: TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Party Mode',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create a room for group challenges.\nPerfect for game nights!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Create room
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _createRoom,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create Room'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD600),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Join room
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.showSuccessSnackBar(
                      'Join room coming soon! (Demo mode)');
                },
                icon: const Icon(Icons.login),
                label: const Text('Join Room'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(
                      color: AppColors.textMuted.withValues(alpha: 0.3)),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoom(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room code header
          GlassmorphicCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFD600).withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            child: Row(
              children: [
                const Text('\u{1F3B2}', style: TextStyle(fontSize: 32)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ROOM CODE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 1,
                          color: Color(0xFFFFD600),
                        ),
                      ),
                      Text(
                        _roomCode ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.showSuccessSnackBar(
                      'Code copied! (Demo mode)'),
                  icon: const Icon(Icons.copy, color: Color(0xFFFFD600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Participants
          Text(
            'PLAYERS (${_demoParticipants.length})',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _demoParticipants.map((p) {
              return Chip(
                avatar: Text(p['emoji']!, style: const TextStyle(fontSize: 16)),
                label: Text(
                  p['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Room bets
          Text(
            'ACTIVE BETS',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._demoRoomBets.map((bet) {
            return GlassmorphicCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bet['title'] as String,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${bet['wager']} tokens \u2022 ${bet['picks']} picks in',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showSuccessSnackBar(
                        'Pick made! (Demo mode)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD600),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    child: const Text('Pick'),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xl),

          // Create new bet button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () =>
                  context.showSuccessSnackBar('New bet created! (Demo mode)'),
              icon: const Icon(Icons.add),
              label: const Text('New Group Bet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFFD600),
                side: const BorderSide(color: Color(0xFFFFD600)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Leave room
          Center(
            child: TextButton(
              onPressed: () => setState(() => _inRoom = false),
              child: Text(
                'Leave Room',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
