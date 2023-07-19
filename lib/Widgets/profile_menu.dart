import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {


  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    required this.isDark,
  }) : super(key : key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon ;
  final Color? textColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isDark? Colors.white.withOpacity(0.8) : Colors.deepPurpleAccent.withOpacity(0.3),
          ),
          child: Icon(
            icon,
            color: isDark? Colors.deepPurple : Colors.deepPurpleAccent,
          )
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:isDark? Colors.white70.withOpacity(0.5) :  Colors.black87.withOpacity(0.2),
          ),
          child: const Icon(
              Icons.chevron_right,
              color: Colors.black54,
              size: 30
          )
      ) : null,
    );
  }
}