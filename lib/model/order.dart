import 'package:wooapp/model/customer_profile.dart';
import 'package:wooapp/model/line_item.dart';

class Order {
  int id;
  int parentId;
  String number;
  String orderKey;
  String createdVia;
  String status;
  String currency;
  String dateCreated;
  String dateCreatedGmt;
  String dateModified;
  String dateModifiedGmt;
  String discountTotal;
  String discountTax;
  String shippingTotal;
  String shippingTax;
  String cartTax;
  String total;
  String totalTax;
  bool pricesIncludeTax;
  int customerId;
  String customerIpAddress;
  String customerUserAgent;
  String customerNote;
  CustomerBilling billing;
  CustomerShipping shipping;
  String paymentMethod;
  String paymentMethodTitle;
  String transactionId;
  String datePaid;
  String datePaidGmt;
  String dateCompleted;
  String dateCompletedGmt;
  String cartHash;
  List<LineItem> lineItems;

  Order.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      parentId = json['parent_id'],
      number = json['number'],
      orderKey = json['order_key'],
      createdVia = json['created_via'],
      status = json['status'],
      currency = json['currency'],
      dateCreated = json['date_created'],
      dateCreatedGmt = json['date_created_gmt'],
      dateModified = json['date_modified'],
      dateModifiedGmt = json['date_modified_gmt'],
      discountTotal = json['discount_total'],
      discountTax = json['discount_tax'],
      shippingTotal = json['shipping_total'],
      shippingTax = json['shipping_tax'],
      cartTax = json['cart_tax'],
      total = json['total'],
      totalTax = json['total_tax'],
      pricesIncludeTax = json['prices_include_tax'],
      customerId = json['customer_id'],
      customerIpAddress = json['customer_ip_address'],
      customerUserAgent = json['customer_user_agent'],
      customerNote = json['customer_note'],
      billing = CustomerBilling.fromJson(json['billing']),
      shipping = CustomerShipping.fromJson(json['shipping']),
      paymentMethod = json['payment_method'],
      paymentMethodTitle = json['payment_method_title'],
      transactionId = json['transaction_id'],
      datePaid = json['date_paid'] ?? '',
      datePaidGmt = json['date_paid_gmt'] ?? '',
      dateCompleted = json['date_completed'] ?? '',
      dateCompletedGmt = json['date_completed_gmt'] ?? '',
      cartHash = json['cart_hash'],
      lineItems = (json['line_items'] as List).map((item) => LineItem.fromJson(item)).toList();
}
