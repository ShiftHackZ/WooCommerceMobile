class PaymentMethod {
  String id;
  String title;
  String description;
  int order;
  bool enabled;
  String methodTitle;
  String methodDescription;
  List<String> methodSupports;
  PaymentMethodSettings settings;

  PaymentMethod.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      description = json['description'],
      order = int.tryParse(json['order']) ?? 0,
      enabled = json['enabled'],
      methodTitle = json['method_title'],
      methodDescription = json['method_description'],
      methodSupports = (json['method_supports'] as List).map((str) => '$str').toList(),
      settings = PaymentMethodSettings.fromJson(json['settings']);
}

class PaymentMethodSettings {
  PaymentMethodSetting? title;
  // PaymentMethodSetting? instructions;

  PaymentMethodSettings.fromJson(Map<String, dynamic> json)
    : title = PaymentMethodSetting.fromJson(json['title']);
      // instructions = PaymentMethodSetting.fromJson(json['instructions']);
}

class PaymentMethodSetting {
  String id;
  String label;
  String description;
  String type;
  String value;
  String defaultValue;
  String tip;
  String placeholder;

  PaymentMethodSetting.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      label = json['label'],
      description = json['description'],
      type = json['type'],
      value = json['value'],
      defaultValue = json['default'],
      tip = json['tip'],
      placeholder = json['placeholder'];
}
