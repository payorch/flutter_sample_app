import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';
import 'package:test_app/ui/configuration/includes/address.dart';
import 'package:test_app/ui/configuration/includes/payment_detail.dart';
import 'package:test_app/ui/configuration/includes/tab_selector.dart';
import 'package:test_app/utils/HexColor.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  ConfigurationState createState() => ConfigurationState();
}

class ConfigurationState extends State<Configuration> {
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);

  String _environment = "Prod";
  String _language = "Arabic";

  Map<String, bool> _paymentOptions = {
    "show_billing": false,
    "show_shipping": false,
    "show_save_card": false,
    "card_on_file": false,
  };

  final List<String> _themeOptions = [
    "Gd.Theme.DayNight.NoActionBar (default)",
    "Gd.Theme.Material3.DayNight.NoActionBar",
    "Gd.Base.Theme.DayNight.NoActionBar (white-label)",
    "Gd.Base.Theme.NoActionBar (white-label)",
    "Gd.Base.Theme.Light.NoActionBar (white-label)",
    "Gd.Base.Theme.Material3.DayNight.NoActionBar (white-label)",
    "Gd.Base.Theme.Material3.Light.NoActionBar (white-label)",
    "Gd.Base.Theme.Material3.DynamicColors.DayNight (white-label)",
    "Theme.Sdk.Example.Simple",
    "Theme.Sdk.Example.Outlined",
    "Theme.Sdk.Example.Filled",
  ];

  final List<String> _paymentOperations = [
    'Default (merchant configuration)',
    'Pay',
    'PreAuthorize',
    'AuthorizeCapture'
  ];

  final TextEditingController _merchantKeyController = TextEditingController();
  final TextEditingController _merchantPasswordController =
      TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _callbackUrlController = TextEditingController();
  final TextEditingController _paymentIntentIdController =
      TextEditingController();
  final TextEditingController _merchantReferenceIdController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();

  final TextEditingController _billingCity = TextEditingController();
  final TextEditingController _billingStreet = TextEditingController();
  final TextEditingController _billingCountryCode = TextEditingController();
  final TextEditingController _billingPostalCode = TextEditingController();

  final TextEditingController _shippingCity = TextEditingController();
  final TextEditingController _shippingStreet = TextEditingController();
  final TextEditingController _shippingCountryCode = TextEditingController();
  final TextEditingController _shippingPostalCode = TextEditingController();

  String _savedPaymentOperation = "";

  Color _colorText = const Color(0xffffffff);
  Color _colorCard = const Color(0xffff4d00);
  Color _colorPayButton = const Color(0xffff4d00);
  Color _colorCancelButton = const Color(0xff878787);
  Color _colorBG = const Color(0xff2c2222);

  @override
  void initState() {
    super.initState();

    /*WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => loadBody = true));*/
    _setData();
  }

  void _setData() async {
    _environment = await keyEnvironment.getPrefData() ?? _environment;
    _language = (await keySdkLanguage.getPrefData() ?? "AR") == "EN"
        ? "English"
        : _language;
    _savedPaymentOperation =
        await keyPaymentOperation.getPrefData() ?? _paymentOperations[0];

    _paymentOptions = {
      "show_billing": (await keyShowBilling.getPrefData() == "true"),
      "show_shipping": (await keyShowShipping.getPrefData() == "true"),
      "show_save_card": (await keyShowSaveCard.getPrefData() == "true"),
      "card_on_file": (await keyCardOnFile.getPrefData() == "true"),
    };

    _merchantKeyController.text = await keyMerchantKey.getPrefData() ??
        ""; //'f7bdf1db-f67e-409b-8fe7-f7ecf9634f70';
    _merchantPasswordController.text = await keyMerchantPass.getPrefData() ??
        ""; //'0c9b36c1-3410-4b96-878a-dbd54ace4e9a';
    _currencyController.text = 'EGP';
    _callbackUrlController.text = await keyCallbackUrl.getPrefData() ?? "";
    _paymentIntentIdController.text =
        await keyPaymentIntentId.getPrefData() ?? "";
    _merchantReferenceIdController.text =
        await keyMerchantRefId.getPrefData() ?? "";
    _customerEmailController.text = await keyCustomerEmail.getPrefData() ?? "";

    _billingCity.text = await keyBillingCity.getPrefData() ?? "";
    _billingStreet.text = await keyBillingStreet.getPrefData() ?? "";
    _billingCountryCode.text = await keyBillingCountryCode.getPrefData() ?? "";
    _billingPostalCode.text = await keyBillingPostalCode.getPrefData() ?? "";

    _shippingCity.text = await keyShippingCity.getPrefData() ?? "";
    _shippingStreet.text = await keyShippingStreet.getPrefData() ?? "";
    _shippingCountryCode.text =
        await keyShippingCountryCode.getPrefData() ?? "";
    _shippingPostalCode.text = await keyShippingPostalCode.getPrefData() ?? "";

    _colorText =
        HexColor.fromHex(await keyColorText.getPrefData() ?? _colorText.hex);
    _colorCard =
        HexColor.fromHex(await keyColorCard.getPrefData() ?? _colorCard.hex);
    _colorPayButton = HexColor.fromHex(
        await keyColorPayButton.getPrefData() ?? _colorPayButton.hex);
    _colorCancelButton = HexColor.fromHex(
        await keyColorCancelButton.getPrefData() ?? _colorCancelButton.hex);
    _colorBG = HexColor.fromHex(await keyColorBG.getPrefData() ?? _colorBG.hex);

    setState(() {});

    _addListener();
  }

  void _addListener() {
    _merchantKeyController.addListener(() {
      _merchantKeyController.text.toString().addPrefData(keyMerchantKey);
    });
    _merchantPasswordController.addListener(() {
      _merchantPasswordController.text.toString().addPrefData(keyMerchantPass);
    });
    _currencyController.addListener(() {
      _currencyController.text.toString().addPrefData(keyCurrency);
    });
    _callbackUrlController.addListener(() {
      _callbackUrlController.text.toString().addPrefData(keyCallbackUrl);
    });
    _paymentIntentIdController.addListener(() {
      _paymentIntentIdController.text
          .toString()
          .addPrefData(keyPaymentIntentId);
    });
    _merchantReferenceIdController.addListener(() {
      _merchantReferenceIdController.text
          .toString()
          .addPrefData(keyMerchantRefId);
    });
    _customerEmailController.addListener(() {
      _customerEmailController.text.toString().addPrefData(keyCustomerEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuration"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enviroment",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          TabSelector(
              title1: 'Preprod',
              title2: 'Prod',
              selectedTitle: _environment,
              onClick: (type) {
                setState(() {
                  _environment = type;
                });
                type.addPrefData(keyEnvironment);
              }),
          _merchant(),
          _verticalSizeBox,
          Text(
            "SDK Language",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          TabSelector(
              title1: 'English',
              title2: 'Arabic',
              selectedTitle: _language,
              onClick: (type) {
                setState(() {
                  _language = type;
                });
                (type == "English" ? "EN" : "AR").addPrefData(keySdkLanguage);
              }),
          PaymentDetail(
              savedPaymentOperation: _savedPaymentOperation,
              paymentOperations: _paymentOperations,
              currencyController: _currencyController,
              callbackUrlController: _callbackUrlController,
              paymentIntentIdController: _paymentIntentIdController,
              merchantReferenceIdController: _merchantReferenceIdController,
              paymentOptions: _paymentOptions,
              onCheckChange: (key, value) {
                setState(() {
                  _paymentOptions[key] = value ?? false;
                });
              }),
          _verticalSizeBox,
          Text(
            "Customer details (Checkout Screen)",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          TextFormField(
            controller: _customerEmailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Customer email",
              counterText: "",
            ),
          ),
          _verticalSizeBox,
          Text(
            "Billing address",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          Address(
            isBilling: true,
            city: _billingCity,
            street: _billingStreet,
            countryCode: _billingCountryCode,
            postalCode: _billingPostalCode,
          ),
          _verticalSizeBox,
          Text(
            "Shipping address",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          Address(
            isBilling: false,
            city: _shippingCity,
            street: _shippingStreet,
            countryCode: _shippingCountryCode,
            postalCode: _shippingPostalCode,
          ),
          Text(
            "UI color schemes",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _colorWidget(
              "Text Color",
              _colorText,
              () => colorPickerDialog(
                  _colorText,
                  (selectedColor) => setState(() {
                        _colorText = selectedColor;
                        selectedColor.hex.addPrefData(keyColorText);
                      }))),
          _colorWidget(
              "Card Color",
              _colorCard,
              () => colorPickerDialog(
                  _colorCard,
                  (selectedColor) => setState(() {
                        _colorCard = selectedColor;
                        selectedColor.hex.addPrefData(keyColorCard);
                      }))),
          _colorWidget(
              "Pay button Color",
              _colorPayButton,
              () => colorPickerDialog(
                  _colorPayButton,
                  (selectedColor) => setState(() {
                        _colorPayButton = selectedColor;
                        selectedColor.hex.addPrefData(keyColorPayButton);
                      }))),
          _colorWidget(
              "Cancel button Color",
              _colorCancelButton,
              () => colorPickerDialog(
                  _colorCancelButton,
                  (selectedColor) => setState(() {
                        _colorCancelButton = selectedColor;
                        selectedColor.hex.addPrefData(keyColorCancelButton);
                      }))),
          _colorWidget(
              "Background Color",
              _colorBG,
              () => colorPickerDialog(
                  _colorBG,
                  (selectedColor) => setState(() {
                        _colorBG = selectedColor;
                        selectedColor.hex.addPrefData(keyColorBG);
                      }))),
        ],
      ),
    );
  }

  Widget _merchant() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enviroment",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              _horizontalSizeBox,
              const Icon(Icons.info_outline_rounded),
            ],
          ),
          _verticalSizeBox,
          TextFormField(
            controller: _merchantKeyController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Merchant key",
              counterText: "",
            ),
          ),
          _verticalSizeBox,
          TextFormField(
            controller: _merchantPasswordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(),
              labelText: "Merchant password",
              counterText: "",
            ),
          ),
          _verticalSizeBox,
          ElevatedButton(
            onPressed: () {},
            child: Center(
              child: Text("Store".toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorWidget(String title, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          InkWell(
            onTap: () => onTap(),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> colorPickerDialog(
      Color initialColor, Function(Color) onChangeColor) async {
    return ColorPicker(
      color: initialColor,
      onColorChanged: (Color color) => onChangeColor(color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}
