class CreateOrderRecipient {
  String firstName;
  String lastName;
  String phone;
  String email;

  CreateOrderRecipient(this.firstName, this.lastName, this.phone, this.email);

  CreateOrderRecipient.empty()
    : firstName = '',
      lastName = '',
      phone = '',
      email = '';
}

class CreateOrderShipping {
  String country;
  String state;
  String city;
  String index;
  String address1;
  String address2;

  CreateOrderShipping(this.country, this.state, this.city, this.index, this.address1, this.address2);

  CreateOrderShipping.empty()
    : country = '',
      state = '',
      city = '',
      index = '',
      address1 = '',
      address2 = '';
}

enum CreateOrderValidationError {
  TERMS_NOT_ACCEPTED,
  ADDRESS_EMPTY,
  RECIPIENT_EMPTY
}

