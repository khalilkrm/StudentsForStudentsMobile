import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/molecules/social_button.dart';

class DisplaySocialButtons extends StatelessWidget {
  final List<SocialButton> _socialButtons;

  const DisplaySocialButtons(
      {super.key, required List<SocialButton> socialButtons})
      : _socialButtons = socialButtons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <SocialButton>[
          ..._socialButtons,
        ],
      ),
    );
  }
}
