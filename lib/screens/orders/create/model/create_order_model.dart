class CreateOrderRecipient {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  CreateOrderRecipient(this.firstName, this.lastName, this.phone, this.email);

  const CreateOrderRecipient.empty()
    : firstName = '',
      lastName = '',
      phone = '',
      email = '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOrderRecipient &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          phone == other.phone &&
          email == other.email;

  @override
  int get hashCode =>
      firstName.hashCode ^ lastName.hashCode ^ phone.hashCode ^ email.hashCode;
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

