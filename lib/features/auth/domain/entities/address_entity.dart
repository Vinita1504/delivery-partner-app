/// Address entity in the domain layer
class AddressEntity {
  final String street;
  final String city;
  final String state;
  final String zip;
  final String country;

  const AddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });
}
