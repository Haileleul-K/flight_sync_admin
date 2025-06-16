import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<Widget>? contents;

  const CustomCard({
    Key? key,
    required this.title,
    this.contents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contents ?? [],
            )
          ],
        ),
      ),
    );
  }
}
