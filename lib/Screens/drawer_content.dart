import 'package:flutter/material.dart';
import 'package:nirogh/Screens/profile_setup.dart';
import 'package:nirogh/Widgets/profile_menu.dart';
import 'package:nirogh/main.dart';
import 'package:nirogh/services/auth_service.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  _DrawerContent createState() => _DrawerContent();
}

class _DrawerContent extends State<DrawerContent> {
  // Define your variables here

  @override
  void initState() {
    super.initState();
    // Initialize your variables or perform any other setup operations
  }
  @override
  void dispose() {
    super.dispose();
    // Clean up any resources or subscriptions
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        var isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

        return MaterialApp(
          // theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              // appBar: AppBar(
              //   // backgroundColor: isDarkMode ? Colors.black : Colors.white,
              //   leading: IconButton(
              //     onPressed: () {},
              //     icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
              //   ),
              //   title: Text(
              //     "Profile",
              //     style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              //   ),
              //   actions: [
              //     IconButton(
              //       onPressed: (){
              //
              //       },
              //       icon: Icon(
              //         isDarkMode ? Icons.light_mode : Icons.dark_mode,
              //         color: isDarkMode ? Colors.white : Colors.black,
              //       ),
              //     ),
              //   ],
              // ),

              body: Container(
                decoration: BoxDecoration(
                    gradient: !isDarkMode? LinearGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.5),
                          Colors.white70,
                          Colors.white70,
                          Colors.white70,
                          Colors.cyanAccent.withOpacity(0.5)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    ):
                    const LinearGradient(
                        colors: [
                          Colors.white70,
                          Colors.black26,
                          Colors.black38,
                          Colors.black26,
                          Colors.white70
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                    )
                ),

                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Stack(
                              children: [
                                const SizedBox(
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 19,
                                    child: IconButton(
                                      onPressed: () {},
                                      color: Colors.black,
                                      icon: const Icon(Icons.edit, size: 18),
                                    ),
                                  ),

                                ),
                              ]
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "Priyanshu Mallick",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 30,
                              )
                          ),
                          Text(
                              "clgpriyanshumallick@gmail.com",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.black54,
                                fontSize: 18,
                              )
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => UpdateProfileScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow, side: BorderSide.none, shape: const StadiumBorder()
                            ),
                            child: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 10),
                          //MENU
                          ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: (){}, isDark: isDarkMode),
                          ProfileMenuWidget(title: "BillingDetails", icon: Icons.wallet, onPress: (){}, isDark: isDarkMode),
                          ProfileMenuWidget(title: "User Management", icon: Icons.verified_user, onPress: (){}, isDark: isDarkMode),
                          const Divider(height: 20),
                          ProfileMenuWidget(title: "Information", icon: Icons.info_outline, onPress: (){}, isDark: isDarkMode),
                          ProfileMenuWidget(
                              title: "Logout",
                              icon: Icons.logout_outlined,
                              textColor: Colors.red,
                              endIcon: false,
                              onPress: (){
                                AuthService.signOut();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => SlidableFlashScreens()),
                                );
                              },
                              isDark: isDarkMode
                          ),
                          const SizedBox()
                        ]
                    )
                ),

              ),
            ),
          ),
        );
      },
    );
  }
}
