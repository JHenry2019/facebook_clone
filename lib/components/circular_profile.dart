import 'package:flutter/material.dart';

class CircularProfile extends StatelessWidget {
  const CircularProfile({super.key, required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + 5,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(
          'assets/profile_sample.jpg',
        ),
      ),
    );
  }
}
