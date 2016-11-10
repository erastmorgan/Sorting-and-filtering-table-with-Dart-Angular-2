class Address {
  String city;
  String street;

  Address(var city, var street) {
    this.city = city;
    this.street = street;
  }

  String toString() => '$city, $street';
}