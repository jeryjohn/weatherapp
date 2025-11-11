import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelb;

  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.labelb,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 45,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              labelb,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
