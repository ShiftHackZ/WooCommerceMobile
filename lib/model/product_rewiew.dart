class ProductReview {
  int id;
  String dateCreated;
  String dateCreatedGmt;
  int productId;
  String status;
  String reviewer;
  String reviewerEmail;
  String review;
  double rating;
  ProductReviewAvatar reviewerAvatar;

  ProductReview.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      dateCreated = json['date_created'],
      dateCreatedGmt = json['date_created_gmt'],
      productId = json['product_id'],
      status = json['status'],
      reviewer = json['reviewer'],
      reviewerEmail = json['reviewer_email'],
      review = json['review'],
      rating = double.tryParse(json['rating'].toString()) ?? 0,
      reviewerAvatar = ProductReviewAvatar.fromJson(json['reviewer_avatar_urls']);
}

class ProductReviewAvatar {
  String x24;
  String x48;
  String x96;

  ProductReviewAvatar.fromJson(Map<String, dynamic> json)
    : x24 = json['24'],
      x48 = json['48'],
      x96 = json['96'];
}
