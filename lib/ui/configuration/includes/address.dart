import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';

class Address extends StatelessWidget {
  final _horizontalSizeBox = const SizedBox(width: 10.0);

  final bool isBilling;

  final TextEditingController city;
  final TextEditingController street;
  final TextEditingController countryCode;
  final TextEditingController postalCode;

  const Address({
    super.key,
    required this.isBilling,
    required this.city,
    required this.street,
    required this.countryCode,
    required this.postalCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            controller: city,
            onChanged: (String? value) => isBilling
                ? value.addPrefData(keyBillingCity)
                : value.addPrefData(keyShippingCity),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Street name & number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            controller: street,
            onChanged: (String? value) => isBilling
                ? value.addPrefData(keyBillingStreet)
                : value.addPrefData(keyShippingStreet),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Country Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  controller: countryCode,
                  onChanged: (String? value) => isBilling
                      ? value.addPrefData(keyBillingCountryCode)
                      : value.addPrefData(keyShippingCountryCode),
                ),
              ),
              _horizontalSizeBox,
              Expanded(
                flex: 5,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Postal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  controller: postalCode,
                  onChanged: (String? value) => isBilling
                      ? value.addPrefData(keyBillingPostalCode)
                      : value.addPrefData(keyShippingPostalCode),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
