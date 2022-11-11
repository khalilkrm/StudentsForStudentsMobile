import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final void Function() _onTap;
  final ImageProvider _logo;

  const SocialButton({
    required void Function() onTap,
    required ImageProvider logo,
    super.key,
  })
      : _onTap = onTap,
        _logo = logo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
            image: DecorationImage(
              image: _logo,
            ),
          ),
        )
    );
  }
}

