import 'package:contact/theme/app_colors.dart';
import 'package:contact/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  final String? name; // OPTIONAL
  final String phoneNumber;

  const CallPage({
    super.key,
    this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contact info
              if (name != null) ...[
          Text(
          name!,
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          phoneNumber,
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
        ] else ...[
      Text(
      phoneNumber,
      style: AppTextStyles.title,
        textAlign: TextAlign.center,
      ),
        ],

              const SizedBox(height: 10),

              const Text(
                "Calling...",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 60),

              // TOP BUTTONS (Mute + Speaker)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roundButton(
                    color: AppColors.textLight,
                    icon: Icons.mic_off,
                    onTap: () {},
                  ),
                  _roundButton(
                    color: AppColors.textLight,
                    icon: Icons.volume_up,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // END CALL BUTTON (Centered)
              _roundButton(
                icon: Icons.call_end,
                color: Colors.red,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Round button widget
  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: color,
        child: Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
