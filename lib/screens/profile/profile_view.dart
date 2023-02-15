import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:untitled/model/customer_profile.dart';
import 'package:untitled/screens/auth/login.dart';
import 'package:untitled/screens/auth/no_auth_screen.dart';
import 'package:untitled/screens/gallery/gallery.dart';
import 'package:untitled/screens/help/help_screen.dart';
import 'package:untitled/screens/map/shop_map_screen.dart';
import 'package:untitled/screens/orders/orders_screen.dart';
import 'package:untitled/screens/profile/edit/profile_edit_screen.dart';
import 'package:untitled/screens/profile/profile_cubit.dart';
import 'package:untitled/screens/profile/profile_state.dart';
import 'package:untitled/screens/profile/shipping/shipping_edit_screen.dart';
import 'package:untitled/screens/settings/settings.dart';
import 'package:untitled/widget/shimmer.dart';
import 'package:untitled/widget/stateful_wrapper.dart';

class ProfileView extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<ProfileCubit>().getProfile();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              //ToDo ...
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case InitialProfileState:
                  return _loadingState(context);
                case LoadingProfileState:
                  return _loadingState(context);
                case ContentProfileState:
                  return _contentState(context, (state as ContentProfileState).profile);
                case ErrorProfileState:
                  return _errorState();
                case NoAuthProfileState:
                  return _noAuth(context);
                default:
                  return _loadingState(context);
              }
            },
          ),
        ),
      )
  );

  Widget _noAuth(BuildContext context) => NoAuthScreen(tr('tab_profile'), () {
    Future.delayed(Duration(milliseconds: 200), () {
      context.read<ProfileCubit>().getProfile();
    });
  });

  Widget _contentState(
      BuildContext context,
      CustomerProfile profile,
  ) => Scaffold(
    appBar: AppBar(
      title: Text('tab_profile').tr(),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator
              .push(context, MaterialPageRoute(builder: (_) => ProfileEditScreen()))
              .then((value) {
                if (value) {
                  context.read<ProfileCubit>().getProfile();
                }
                print('back, context = $context');
              });
          },
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: InkWell(
                              onTap: () => Navigator
                                  .of(context)
                                  .push(MaterialPageRoute(builder: (_) => GalleryScreen([profile.avatar]))),
                              child: CachedNetworkImage(
                                imageUrl: profile.avatar,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Shimmer(
                                    duration: Duration(seconds: 1),
                                    enabled: true,
                                    direction: ShimmerDirection.fromLTRB(),
                                    child: Container(color: Colors.white10)
                                ),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${profile.username}',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${profile.firstName} ${profile.lastName}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              ..._profileSections(context),
            ],
          ),
        ),
      ),
    )
  );

  Widget _loadingState(BuildContext context) => ProfileShimmer(
      _profileSections(context)
  );

  Widget _errorState() => Center(
    child: Text("Error"),
  );

  Widget _profileSection(Widget icon, String text, VoidCallback action, {Color iconBackground = Colors.transparent}) => Padding(
    padding: EdgeInsets.only(left: 8, right: 8),
    child: Card(
      color: Colors.white70,
      child: InkWell(
        onTap: action,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: iconBackground,
                  border: Border.all(
                    color: iconBackground
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                width: 34,
                height: 34,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(child: icon),
                ),
              ),
              SizedBox(width: 12),
              Text(text, style: TextStyle(fontSize: 17)),
              Spacer(),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    ),
  );

  List<Widget> _profileSections(BuildContext context) => [
        SizedBox(height: 8),
        _profileSection(
          FaIcon(FontAwesomeIcons.mapMarkerAlt),
          tr('shipping'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShippingEditScreen()),
          ).then((value) {
            if (value) {
              context.read<ProfileCubit>().getProfile();
            }
            print('back, context = $context');
          }),
        ),
        _profileSection(
          FaIcon(FontAwesomeIcons.cog),
          tr('settings'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SettingsScreen()),
          ).then((value) {
            print('back, context = $context');
          }),
        ),
        SizedBox(height: 8),
        _profileSection(FaIcon(FontAwesomeIcons.heart), tr('wish_list'), () {}),
        _profileSection(
          FaIcon(FontAwesomeIcons.shoppingBag),
          tr('orders'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrdersScreen()),
          ),
        ),
        _profileSection(
          FaIcon(FontAwesomeIcons.ticketAlt),
          tr('coupons'),
          () {},
        ),
        SizedBox(height: 8),
        _profileSection(
          FaIcon(FontAwesomeIcons.map),
          tr('shops'),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ShopMap()),
          ),
        ),
        _profileSection(
          FaIcon(FontAwesomeIcons.questionCircle),
          tr('help'),
          () => Navigator
              .of(context)
              .push(MaterialPageRoute(builder: (_) => HelpScreen())),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            context.read<ProfileCubit>().logout();
          },
          child: Container(
            width: 90,
            alignment: Alignment.center,
            child: Text(
              'logout',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ).tr(),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFFF56E6E)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
                side: BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Version: 0.1 Alpha',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 16),
      ];
}
