import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper to ensure the app looks like a mobile phone on Web/Desktop.
/// It constrains the width to 480px and centers it.
class MobileWrapper extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const MobileWrapper({
    super.key,
    required this.child,
    this.backgroundColor =
        Colors.black, // Default to black background for "theater mode"
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            // Optional: Add rounded corners for a "phone" feel
            // borderRadius: BorderRadius.circular(20),
            // remove border radius for now to avoid clipping status bar on real mobile web
            child: child,
          ),
        ),
      );
    }
    return child;
  }
}
