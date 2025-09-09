import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/paints/clippers.dart';
import 'package:obs_for_sama/core/themes/color_scheme.dart';
import 'package:obs_for_sama/core/themes/text_theme.dart';
import 'package:obs_for_sama/core/widgets/r_s_i_outlined_body.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer/sizer.dart';

class OBSDrawer extends StatelessWidget {
  const OBSDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIOutlinedBody(
      height: double.infinity,
      width: 65.sp,
      edgeClipper: const RSIEdgeClipper(
        edgeRightTop: true,
        edgeRightBottom: true,
      ),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Image.asset('assets/icon-ios-obs-manager-x1.png'),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // spacing: Device.screenType == ScreenType.mobile ? 4.sp : 15.sp,
                  children: <Widget>[
                    ListTile(
                      title: Text('MENU_INFOS_VERSION', style: ktitle2),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('MENU_WORK_FLOW', style: ktitle2),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('MENU_CONF_TWITCH', style: ktitle2),
                    ),
                    ListTile(
                      title: Text('MENU_THEME_SELECT', style: ktitle2),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      iconColor: kTextShadow,
                      title: Text('MENU_SETTINGS', style: ktitle2),
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                  if (kDebugMode) {
                    print(snapshot.data?.version);
                    print('Si la version n‘est pas la même. Il faut cut/restart.');
                  }
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
                      child: Text(
                        'OBSM. v${snapshot.data?.version}',
                        style: kbodyLarge.copyWith(color: kTextShadow, letterSpacing: 9.sp),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: kbodyLarge,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
