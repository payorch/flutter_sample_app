import 'package:flutter/material.dart';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/common/geidea.dart';
import 'package:geideapay/models/address.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';
import 'package:test_app/storage/app_preference.dart';
import 'package:test_app/ui/card_payment/input_card_view.dart';
import 'package:test_app/utils/HexColor.dart';

enum PaymentType { geidea, merchant }

class CardPayment extends StatefulWidget {
  const CardPayment({super.key});

  @override
  CardPaymentState createState() => CardPaymentState();
}

class CardPaymentState extends State<CardPayment> {
  final _plugin = GeideapayPlugin();

  PaymentType? _character = PaymentType.geidea;

  String _currency = "";

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() async {
    _plugin.initialize(
        publicKey: 'f7bdf1db-f67e-409b-8fe7-f7ecf9634f70',
        apiPassword: '0c9b36c1-3410-4b96-878a-dbd54ace4e9a');

    _currency =
        await keyCurrency.getPrefData() ?? await "EGP".addPrefData(keyCurrency);

    _amountController.text =
        await keyAmount.getPrefData() ?? await "100".addPrefData(keyAmount);
    _cardNumberController.text = (await keyCardNumber.getPrefData()).toString();
    _monthController.text = (await keyCardExpMonth.getPrefData()) ?? "";
    _yearController.text = (await keyCardExpYear.getPrefData()) ?? "";
    _cvvController.text = (await keyCardCVV.getPrefData()) ?? "";
    _cardHolderController.text = (await keyCardHolderName.getPrefData()) ?? "";

    if (await keyPaymentType.getPrefData() == "PaymentType.merchant") {
      _character = PaymentType.merchant;
    }

    setState(() {});

    _initListener();
  }

  void _initListener() {
    _amountController.addListener(() async {
      _amountController.text.toString().addPrefData(keyAmount);
    });
    _cardNumberController.addListener(() {
      _cardNumberController.text.toString().addPrefData(keyCardNumber);
    });
    _monthController.addListener(() {
      _monthController.text.toString().addPrefData(keyCardExpMonth);
    });
    _yearController.addListener(() {
      _yearController.text.toString().addPrefData(keyCardExpYear);
    });
    _cvvController.addListener(() {
      _cvvController.text.toString().addPrefData(keyCardCVV);
    });
    _cardHolderController.addListener(() {
      _cardHolderController.text.toString().addPrefData(keyCardHolderName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Payment"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              labelText: "Amount *"),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        _currency,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: const Text("Geidea SDK"),
                    leading: Radio(
                        value: PaymentType.geidea,
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value;
                            value.addPrefData(keyPaymentType);
                          });
                        }),
                    contentPadding: const EdgeInsets.only(left: -100),
                    onTap: () {
                      setState(() {
                        _character = PaymentType.geidea;
                        PaymentType.geidea.addPrefData(keyPaymentType);
                      });
                    },
                  ),
                  ListTile(
                    title: const Text("Merchant PCI-DSS"),
                    leading: Radio(
                        value: PaymentType.merchant,
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value;
                            value.addPrefData(keyPaymentType);
                          });
                        }),
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      setState(() {
                        _character = PaymentType.merchant;
                        PaymentType.merchant.addPrefData(keyPaymentType);
                      });
                    },
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: (_character == PaymentType.merchant)
                        ? InputCardView(
                            cardNumberController: _cardNumberController,
                            monthController: _monthController,
                            yearController: _yearController,
                            cvvController: _cvvController,
                            cardHolderController: _cardHolderController,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _payNow(context),
            child: const Center(
              child: Text("PAY"),
            ),
          ),
        ],
      ),
    );
  }

  void _payNow(BuildContext buildContext) async {
    FocusScope.of(buildContext).unfocus();
    Address billingAddress = Address(
        city: await keyBillingCity.getPrefData(),
        countryCode: await keyBillingCountryCode.getPrefData(),
        street: await keyBillingStreet.getPrefData(),
        postCode: await keyBillingPostalCode.getPrefData());
    Address shippingAddress = Address(
        city: await keyShippingCity.getPrefData(),
        countryCode: await keyShippingCountryCode.getPrefData(),
        street: await keyShippingStreet.getPrefData(),
        postCode: await keyShippingPostalCode.getPrefData());

    CheckoutOptions checkoutOptions = CheckoutOptions(
      (await keyAmount.getPrefData()).toString(),
      (await keyCurrency.getPrefData()).toString(),
      callbackUrl: (await keyCallbackUrl.getPrefData()).toString(),
      lang: (await keySdkLanguage.getPrefData()).toString(),
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
      customerEmail: (await keyCustomerEmail.getPrefData()).toString(),
      merchantReferenceID: (await keyMerchantRefId.getPrefData()).toString(),
      paymentIntentId: (await keyPaymentIntentId.getPrefData()).toString(),
      paymentOperation: (await keyPaymentOperation.getPrefData()).toString(),
      showShipping: await keyShowShipping.getPrefData() == "true",
      showBilling: await keyShowBilling.getPrefData() == "true",
      showSaveCard: await keyShowSaveCard.getPrefData() == "true",
      textColor:
          HexColor.fromHex(await keyColorText.getPrefData() ?? "#ffffff"),
      cardColor:
          HexColor.fromHex(await keyColorCard.getPrefData() ?? "#ff4d00"),
      payButtonColor:
          HexColor.fromHex(await keyColorPayButton.getPrefData() ?? "#ff4d00"),
      cancelButtonColor: HexColor.fromHex(
          await keyColorCancelButton.getPrefData() ?? "#878787"),
      backgroundColor:
          HexColor.fromHex(await keyColorBG.getPrefData() ?? "#2c2222"),
    );

    try {
      OrderApiResponse response = await _plugin.checkout(
          context: buildContext, checkoutOptions: checkoutOptions);
      debugPrint('Response = $response');

      //_updateStatus(response.detailedResponseMessage, truncate(response.toString()));
    } catch (e) {
      debugPrint("PayNow: $e");
      //_showMessage(e.toString());
    }
  }
}
