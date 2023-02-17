import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/extensions/extensions_widget.dart';

class ProductScreenShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: WooAppTheme.colorToolbarBackground,
    ),
    backgroundColor: WooAppTheme.colorCommonBackground,
    bottomNavigationBar: Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8, right: 16, left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: WooAppTheme.colorShimmerBackground,
              radius: 22,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                child: shimmer(),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 30,
              height: 14,
              child: shimmer(),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: WooAppTheme.colorShimmerBackground,
              radius: 22,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(22)),
                child: shimmer(),
              ),
            ),
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(22)),
              child: Container(
                width: 142,
                height: 46,
                child: shimmer(),
              ),
            ),
          ],
        ),
      ),
    ),
    body: SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 280,
                child: shimmer(),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 22,
                          child: shimmer(),
                        ),
                        Spacer(),
                        Container(
                          width: 90,
                          height: 14,
                          child: shimmer(),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 250,
                      height: 22,
                      child: shimmer(),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            width: 100,
                            height: 36,
                            child: shimmer(),
                          ),
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: WooAppTheme.colorShimmerBackground,
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: shimmer(),
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: WooAppTheme.colorShimmerBackground,
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: shimmer(),
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: WooAppTheme.colorShimmerBackground,
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: shimmer(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    SizedBox(height: 12),
                    Container(
                      width: 300,
                      height: 15,
                      child: shimmer(),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 280,
                      height: 15,
                      child: shimmer(),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 310,
                      height: 15,
                      child: shimmer(),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 190,
                      height: 15,
                      child: shimmer(),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CartListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _buildCartItem(context),
      _buildCartItem(context),
      _buildCartItem(context),
      _buildCartItem(context),
    ],
  );

  Widget _buildCartItem(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: WooAppTheme.colorCardProductBackground,
      clipBehavior: Clip.antiAlias,
      child: Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: Shimmer(
                    duration: Duration(seconds: 1),
                    enabled: true,
                    direction: ShimmerDirection.fromLTRB(),
                    color: WooAppTheme.colorShimmerForeground,
                    child: Container(
                      color: WooAppTheme.colorShimmerBackground,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 8, right: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              height: 16,
                              child: Shimmer(
                                duration: Duration(seconds: 1),
                                enabled: true,
                                direction: ShimmerDirection.fromLTRB(),
                                color: WooAppTheme.colorShimmerForeground,
                                child: Container(
                                  color: WooAppTheme.colorShimmerBackground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 100,
                        height: 17,
                        padding: EdgeInsets.only(left: 8, right: 6),
                        child: Shimmer(
                          duration: Duration(seconds: 1),
                          enabled: true,
                          direction: ShimmerDirection.fromLTRB(),
                          color: WooAppTheme.colorShimmerForeground,
                          child: Container(
                            color: WooAppTheme.colorShimmerBackground,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 150,
                        height: 17,
                        padding: EdgeInsets.only(left: 8, right: 6),
                        child: Shimmer(
                          duration: Duration(seconds: 1),
                          enabled: true,
                          direction: ShimmerDirection.fromLTRB(),
                          color: WooAppTheme.colorShimmerForeground,
                          child: Container(
                            color: WooAppTheme.colorShimmerBackground,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class FeaturedCategoriesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      _item(),
      _item(),
      _item(),
      _item(),
      _item(),
    ],
  );

  Widget _item() => Container(
    child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            color: WooAppTheme.colorCardProductBackground,
            clipBehavior: Clip.antiAlias,
            child: Shimmer(
              duration: Duration(seconds: 1),
              enabled: true,
              direction: ShimmerDirection.fromLTRB(),
              color: WooAppTheme.colorShimmerForeground,
              child: Container(
                color: WooAppTheme.colorShimmerBackground,
              ),
            ),
          ),
        ),
        Container(
          width: 100,
          height: 14,
          child: Shimmer(
            duration: Duration(seconds: 1),
            enabled: true,
            direction: ShimmerDirection.fromLTRB(),
            color: WooAppTheme.colorShimmerForeground,
            child: Container(
              color: WooAppTheme.colorShimmerBackground,
            ),
          ),
        )
      ],
    ),
  );
}

class FeaturedShimmer extends StatelessWidget {

  final bool isInitial;

  FeaturedShimmer(this.isInitial);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(child: _item(context)),
          Expanded(child: _item(context)),
        ],
      ),
      if (isInitial) Row(
        children: [
          Expanded(child: _item(context)),
          Expanded(child: _item(context)),
        ],
      ),
      if (isInitial) Row(
        children: [
          Expanded(child: _item(context)),
          Expanded(child: _item(context)),
        ],
      ),
    ],
  );

  Widget _item(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    color: WooAppTheme.colorCardProductBackground,
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height / 6),
          child: Shimmer(
            duration: Duration(seconds: 1),
            enabled: true,
            direction: ShimmerDirection.fromLTRB(),
            color: WooAppTheme.colorShimmerForeground,
            child: Container(
              color: WooAppTheme.colorShimmerBackground,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 8, right: 4),
          child: Container(
            width: 100,
            height: 14,
            child: Shimmer(
              duration: Duration(seconds: 1),
              enabled: true,
              direction: ShimmerDirection.fromLTRB(),
              color: WooAppTheme.colorShimmerForeground,
              child: Container(
                color: WooAppTheme.colorShimmerBackground,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: 8, right: 4),
          child: Container(
            width: 100,
            height: 14,
            child: Shimmer(
              duration: Duration(seconds: 1),
              enabled: true,
              direction: ShimmerDirection.fromLTRB(),
              color: WooAppTheme.colorShimmerForeground,
              child: Container(
                color: WooAppTheme.colorShimmerBackground,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ProfileShimmer extends StatelessWidget {
  final List<Widget> sections;

  ProfileShimmer(this.sections);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('tab_profile').tr(),
        elevation: 0,
        leading: Icon(Icons.person),
        backgroundColor: WooAppTheme.colorToolbarBackground,
      ),
      backgroundColor: WooAppTheme.colorCommonBackground,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: WooAppTheme.colorToolbarBackground,
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
                              child: Shimmer(
                                duration: Duration(seconds: 1),
                                enabled: true,
                                direction: ShimmerDirection.fromLTRB(),
                                color: WooAppTheme.colorShimmerForeground,
                                child: Container(
                                  color: WooAppTheme.colorShimmerBackground,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          width: 200,
                          height: 16,
                          child: Shimmer(
                            duration: Duration(seconds: 1),
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            color: WooAppTheme.colorShimmerForeground,
                            child: Container(
                              color: WooAppTheme.colorShimmerBackground,
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          width: 200,
                          height: 16,
                          child: Shimmer(
                            duration: Duration(seconds: 1),
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            color: WooAppTheme.colorShimmerForeground,
                            child: Container(
                              color: WooAppTheme.colorShimmerBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...sections,
              ],
            ),
          ),
        ),
      ),
  );

  Widget _shimmerSection() => Padding(
    padding: EdgeInsets.only(left: 8, right: 8),
    child: Card(
      color: Colors.white70,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Shimmer(
                duration: Duration(seconds: 1),
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
                color: WooAppTheme.colorShimmerForeground,
                child: Container(
                  color: WooAppTheme.colorShimmerBackground,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                width: 450,
                height: 17,
                child: Shimmer(
                  duration: Duration(seconds: 1),
                  enabled: true,
                  direction: ShimmerDirection.fromLTRB(),
                  color: WooAppTheme.colorShimmerForeground,
                  child: Container(
                    color: WooAppTheme.colorShimmerBackground,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    ),
  );
}
