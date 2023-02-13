class FeaturedFilter {
  static const stockAvailable = 'instock';
  static const stockBackOrder = 'onbackorder';

  String stockStatus = '';
  String category = '';
  String search = '';
  double minPrice = -1;
  double maxPrice = -1;
  bool onSale = false;
  bool featured = false;

  FeaturedFilter({
    this.stockStatus = '',
    this.category = '',
    this.search = '',
    this.minPrice = -1,
    this.maxPrice = -1,
    this.onSale = false,
    this.featured = false
  });

  FeaturedFilter.empty();

  bool isApplied() {
    return !(stockStatus == ''
        && minPrice == -1
        && maxPrice == -1
        && onSale == false
        && featured == false
    );
  }

  void clear() {
    stockStatus = '';
    category = '';
    minPrice = -1;
    maxPrice = -1;
    onSale = false;
    featured = false;
  }

  void resetStock() {
    stockStatus = '';
}

  void resetLogic() {
    onSale = false;
    featured = false;
  }

  String query() {
    var result = '';
    if (stockStatus != '') result += '&stock_status=$stockStatus';
    if (category != '') result += '&category=$category';
    if (search != '') result += '&search=$search';
    if (minPrice != -1) result += '&min_price=$minPrice';
    if (maxPrice != -1) result += '&max_price=$maxPrice';
    if (onSale) result += '&on_sale=true';
    if (featured) result += '&featured=true';
    return result;
  }

  @override
  String toString() => query();
}