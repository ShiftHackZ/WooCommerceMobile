import 'package:untitled/api/woo_api_client.dart';
import 'package:untitled/database/database.dart';
import 'package:untitled/locator.dart';
import 'package:untitled/model/customer_profile.dart';

class CustomerProfileDataSourceImpl extends CustomerProfileDataSource {
  final WooApiClient _api = locator<WooApiClient>();
  final AppDb _db = locator<AppDb>();
  
  @override
  Future<CustomerProfile> getProfile() => _db.getUserId()
      .then((userId) => _api.dio.get('customers/$userId'))
      .then((response) => CustomerProfile.formJson(response.data));

  @override
  Future<CustomerProfile> updateProfile(
      String email,
      String firstName,
      String lastName,
      String phone
  ) => _db.getUserId()
      .then((userId) => _api.dio.put('customers/$userId', data: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'shipping': {
          'first_name': firstName,
          'last_name': lastName,
        },
        'billing': {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone
        }
      }))
      .then((response) => CustomerProfile.formJson(response.data));

  @override
  Future<CustomerProfile> updateShipping(
      String country,
      String city,
      String state,
      String postcode,
      String address1,
      String address2
  ) => _db.getUserId()
      .then((userId) => _api.dio.put('customers/$userId', data: {
        'shipping': {
          'country': country,
          'city': city,
          'state': state,
          'postcode': postcode,
          'address_1': address1,
          'address_2': address2
        },
        'billing': {
          'country': country,
          'city': city,
          'state': state,
          'postcode': postcode,
          'address_1': address1,
          'address_2': address2
        }
      }))
      .then((response) => CustomerProfile.formJson(response.data));
}

abstract class CustomerProfileDataSource {
  Future<CustomerProfile> getProfile();

  Future<CustomerProfile> updateProfile(String username, String firstName, String lastName, String phone);

  Future<CustomerProfile> updateShipping(
      String country,
      String city,
      String state,
      String postcode,
      String address1,
      String address2,
  );
}
