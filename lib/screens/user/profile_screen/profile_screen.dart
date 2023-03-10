import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliit_eats/helpers/cache_service.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/helpers/keys.dart';
import 'package:sliit_eats/helpers/state_helpers.dart';
import 'package:sliit_eats/routes/app_routes.dart';
import 'package:sliit_eats/screens/user/profile_screen/components/change_password_modal.dart';
import 'package:sliit_eats/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/info_card.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings();

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  var progress;
  late User user;
  bool switchValue = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(builder: (context) {
        progress = ProgressHUD.of(context);
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundGradient['top']!,
                AppColors.backgroundGradient['bottom']!,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.14 : MediaQuery.of(context).size.height * 0.24,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.05, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.18 : MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.18 : MediaQuery.of(context).size.width * 0.14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.black.withOpacity(0.1), offset: Offset(0, 0), blurRadius: 8, spreadRadius: 1),
                          ],
                        ),
                        child: ClipOval(child: Image.asset('assets/images/profile.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName != null ? user.displayName! : "Display Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.email!,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidBell,
                              color: AppColors.primary,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Text(
                                "Notifications",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Spacer(),
                            Switch(
                              onChanged: (bool) {
                                setState(() {
                                  StateHelpers.appSettings['notifications'] = bool;
                                  CacheService.savePref('appSettings', jsonEncode(StateHelpers.appSettings));
                                });
                              },
                              value: StateHelpers.appSettings['notifications'] ?? true,
                              activeColor: AppColors.primary,
                              activeTrackColor: AppColors.primary.withOpacity(0.3),
                              inactiveThumbColor: AppColors.primary,
                              inactiveTrackColor: AppColors.primary.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    InfoCard(
                      title: "Change Password",
                      borderRadius: BorderRadius.zero,
                      showArrow: true,
                      onArrowTap: () {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChangePasswordModal();
                            });
                      },
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    InfoCard(title: "Terms & Conditions", borderRadius: BorderRadius.zero, showArrow: true),
                    SizedBox(
                      height: 4,
                    ),
                    InfoCard(
                      title: "Updates",
                      subtitle: "App fixes and new features",
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      showArrow: true,
                      onArrowTap: () async {
                        await launch('https://github.com/sliit-foss/sliit-eats/releases');
                      },
                    ),
                    Keys.PREMIUM_SUPPORT_ENABLED_USERS.split(",").contains(user.uid)
                        ? Column(
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              InfoCard(
                                title: "Premium Support",
                                subtitle: "+94763412876",
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                showArrow: true,
                                onArrowTap: () async {
                                  await launch('tel://+94763412876');
                                  debugPrint("telephone app launched - code: Q1RGe3BpY0tfb05fNU9tM09uZV95T3VyXzB3Tl9zSXozfQ==");
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          )
                        : SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await AuthService.signOut();
                        Navigator.pushReplacementNamed(context, AppRoutes.AUTH);
                      },
                      child: InfoCard(
                        title: "Sign Out",
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        showArrow: false,
                        icon: FontAwesomeIcons.signOutAlt,
                        iconColor: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
