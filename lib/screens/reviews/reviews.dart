import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wooapp/config/config.dart';
import 'package:wooapp/datasource/product_review_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/product_rewiew.dart';
import 'package:wooapp/screens/reviews/review_add.dart';
import 'package:wooapp/widget/widget_review_item.dart';

class ReviewsScreen extends StatefulWidget {
  final int productId;

  ReviewsScreen(this.productId);

  @override
  State<StatefulWidget> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

  final ProductReviewDataSource _ds = locator<ProductReviewDataSource>();

  final PagingController<int, ProductReview> _pagingController = PagingController(firstPageKey: 1);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('reviews').tr(),
    ),
    bottomNavigationBar: _bottomBar(),
    body: SafeArea(
      child: Container(
        child: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ProductReview>(
            itemBuilder: (context, item, index) => ReviewItemWidget(item),
          ),
          // scrollDirection: Axis.vertical,
        ),
      ),
    ),
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetch(pageKey));
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetch(int page) async {
    try {
      final items = await _ds.getReviews(widget.productId, page).catchError((error, stackTrace) {
        print(error.toString());
      });
      final isLast = items.length < WooAppConfig.paginationLimit;
      if (isLast) {
        _pagingController.appendLastPage(items);
      } else {
        final next = page + 1;
        _pagingController.appendPage(items, next);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  Widget _bottomBar() => Container(
    padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
    height: 60,
    child: ElevatedButton(
      onPressed: () =>Navigator
          .push(context, MaterialPageRoute(builder: (_) => AddReviewScreen(widget.productId)))
          .then((value) {
        // Future.delayed(Duration(milliseconds: 200), () {
        //   context.read<ProfileCubit>().getProfile();
        // });
        print('back, value = $value');
      }),
      child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.commentMedical),
              SizedBox(width: 8),
              Text(
                'review_add',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ).tr(),
            ],
          )
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF62A1E2)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Colors.blue)
          ),
        ),
      ),
    ),
  );
}
