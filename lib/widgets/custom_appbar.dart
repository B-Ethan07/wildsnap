import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildsnap/theme.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppbar({
    super.key,});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    return AppBar(
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.pets,
                  color: Colors.white,
                  size: 34,
                ),
                SizedBox(width: 8),
                Text(
                  'WildSnap',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: provider.isDark,
              onChanged: (_) => provider.toggle(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
