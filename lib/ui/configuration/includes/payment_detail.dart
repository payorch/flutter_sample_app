import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';
import 'package:test_app/ui/configuration/includes/drop_down.dart';

class PaymentDetail extends StatelessWidget {
  final _verticalSizeBox = const SizedBox(height: 20.0);

  final String savedPaymentOperation;

  final List<String> paymentOperations;

  final TextEditingController currencyController;
  final TextEditingController callbackUrlController;
  final TextEditingController paymentIntentIdController;
  final TextEditingController merchantReferenceIdController;
  final Map<String, bool> paymentOptions;
  final Function(String key, bool? value) onCheckChange;

  const PaymentDetail({
    super.key,
    required this.savedPaymentOperation,
    required this.paymentOperations,
    required this.currencyController,
    required this.callbackUrlController,
    required this.paymentIntentIdController,
    required this.merchantReferenceIdController,
    required this.paymentOptions,
    required this.onCheckChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _verticalSizeBox,
        Text(
          "Payment Details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _verticalSizeBox,
        TextFormField(
          controller: currencyController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Currency *",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        Text(
          "Endpoints",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _verticalSizeBox,
        TextFormField(
          controller: callbackUrlController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Callback URL",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        TextFormField(
          controller: paymentIntentIdController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Payment intent ID",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        Text(
          "Payment options",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text("Show Billing"),
                value: paymentOptions["show_billing"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  onCheckChange("show_billing", value);
                  value.addPrefData(keyShowBilling);
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Show Shipping"),
                value: paymentOptions["show_shipping"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  onCheckChange("show_shipping", value);
                  value.addPrefData(keyShowShipping);
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text("Show Save Card"),
                value: paymentOptions["show_save_card"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  onCheckChange("show_save_card", value);
                  value.addPrefData(keyShowSaveCard);
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Card on File"),
                value: paymentOptions["card_on_file"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  onCheckChange("card_on_file", value);
                  value.addPrefData(keyCardOnFile);
                },
              ),
            ),
          ],
        ),
        _verticalSizeBox,
        TextFormField(
          controller: merchantReferenceIdController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Merchant Reference ID",
            counterText: "",
          ),
        ),
        _verticalSizeBox,
        MyDropDown(
            hint: "Payment Operation",
            initialValue: savedPaymentOperation,
            items: paymentOperations,
            keyPref: keyPaymentOperation),
      ],
    );
  }
}
