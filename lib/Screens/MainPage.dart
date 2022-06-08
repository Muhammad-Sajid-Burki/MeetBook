import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/UserViews.dart';
import 'package:dating_app_flutter/Screens/chatRoomScreen.dart';
import 'package:dating_app_flutter/Screens/login_page.dart';
import 'package:dating_app_flutter/Screens/profile_page.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  late String title;

  int _selectedIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final userProvider =  Provider.of<UserProvider>(context, listen: false);
    print(userProvider.userModel.gender);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SliderDrawer(
            appBar: SliderAppBar(
                drawerIconColor: Palette.fullBlue,
                appBarColor: Palette.secondary,
                title: Text("MeetBook",
                    style:  TextStyle(
                        color: Palette.fullBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.w700))),
            key: _key,
            sliderOpenSize: 179,
            slider: _SliderView(
              onItemClick: (title) {
                _key.currentState!.closeSlider();
                // setState(() {
                //   this.title = title;
                // });
              },
            ),
            child: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
                children: <Widget>[
                  UserViews(),
                  ChatRoom(),
                  ProfilePage(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Palette.secondary,
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            _pageController?.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Center(child: Text('Home')),
                activeColor: Palette.fullBlue,
                inactiveColor: Palette.deepBlue),
            BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Center(child: Text('Messages')),
                activeColor: Palette.fullBlue,
                inactiveColor: Palette.deepBlue),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Center(child: Text('Profile')),
                activeColor: Palette.fullBlue,
                inactiveColor: Palette.deepBlue),
          ],
        ));
  }
}

class _SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    return Container(
      color: Palette.secondary,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: Palette.deepBlue,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userProvider.userModel.imageUrl!),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            userProvider.userModel.name!.toUpperCase(),
            style: TextStyle(
              color: Palette.fullBlue,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              // fontFamily: 'BalsamiqSans'
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _SliderMenuItem(
              title: 'LogOut',
              iconData: Icons.logout_rounded,
              onTap: () async {

                await userProvider.logout();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false);
              }),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
          title: Text(title,
              style: TextStyle(
                  color: Palette.fullBlue,
                  // fontFamily: 'BalsamiqSans_Regular'
                  )),
          leading: Icon(
            iconData,
            color: Palette.fullBlue,
          ),
          onTap: onTap),
    );
  }
}
