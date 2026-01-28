import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yume_app/core/theme/app_colors.dart';

/// Wide pill-shaped Dream button with loading state, timer, and dynamic text
class DreamButton extends StatefulWidget {
  const DreamButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  State<DreamButton> createState() => _DreamButtonState();
}

class _DreamButtonState extends State<DreamButton> {
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void didUpdateWidget(DreamButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !oldWidget.isLoading) {
      // Started loading - begin timer
      _elapsedSeconds = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _elapsedSeconds++;
          });
        }
      });
    } else if (!widget.isLoading && oldWidget.isLoading) {
      // Stopped loading - cancel timer
      _timer?.cancel();
      _elapsedSeconds = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Returns progress text based on elapsed time for better UX
  String _getProgressText() {
    if (_elapsedSeconds < 5) {
      return 'Connecting to AI... ${_elapsedSeconds}s';
    } else if (_elapsedSeconds < 30) {
      return 'Weaving your dream... ${_elapsedSeconds}s';
    } else if (_elapsedSeconds < 60) {
      return 'Adding final details... ${_elapsedSeconds}s';
    } else {
      return 'Almost ready... ${_elapsedSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: widget.isEnabled && !widget.isLoading
            ? const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ], // Indigo to Violet
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: widget.isEnabled ? null : AppColors.grey300,
        boxShadow: widget.isEnabled && !widget.isLoading
            ? [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled && !widget.isLoading
              ? widget.onPressed
              : null,
          borderRadius: BorderRadius.circular(28),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isLoading
                  ? Row(
                      key: const ValueKey('loading'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _getProgressText(),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'D R E A M',
                          key: const ValueKey('text'),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
