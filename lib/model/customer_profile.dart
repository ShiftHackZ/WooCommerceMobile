class CustomerProfile {
  int id;
  String email;
  String firstName;
  String lastName;
  String role;
  String username;
  String avatar;
  bool isPayingCustomer;
  CustomerBilling billing;
  CustomerShipping shipping;

  CustomerProfile.formJson(Map<String, dynamic> json)
    : id = json['id'],
      email = json['email'],
      firstName = json['first_name'],
      lastName = json['last_name'],
      role = json['role'],
      username = json['username'],
      avatar = json['avatar_url'],
      isPayingCustomer = json['is_paying_customer'],
      billing = CustomerBilling.fromJson(json['billing']),
      shipping = CustomerShipping.fromJson(json['shipping']);
}

class CustomerBilling {
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String state;
  String postcode;
  String country;
  String email;
  String phone;

  CustomerBilling.fromJson(Map<String, dynamic> json)
    : firstName = json['first_name'],
      lastName = json['last_name'],
      company = json['company'],
      address1 = json['address_1'],
      address2 = json['address_2'],
      city = json['city'],
      state = json['state'],
      postcode = json['postcode'],
      country = json['country'],
      email = json['email'],
      phone = json['phone'];
}

class CustomerShipping {
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String state;
  String postcode;
  String country;

  CustomerShipping.fromJson(Map<String, dynamic> json)
    : firstName = json['first_name'],
      lastName = json['last_name'],
      company = json['company'],
      address1 = json['address_1'],
      address2 = json['address_2'],
      city = json['city'],
      state = json['state'],
      postcode = json['postcode'],
      country = json['country'];
}
