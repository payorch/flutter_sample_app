import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';
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

  final List<String> _initiatedItem = [
    'Internet',
    'Merchant',
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

  String _savedPaymentOpration = "";
  String _billingCity = "";
  String _billingStreet = "";
  String _billingCountryCode = "";
  String _billingPostalCode = "";
  String _shippingCity = "";
  String _shippingStreet = "";
  String _shippingCountryCode = "";
  String _shippingPostalCode = "";

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
    _language = (await keySdkLanguage.getPrefData() ?? _language) == "EN"
        ? "English"
        : _language;
    _savedPaymentOpration =
        await keyPaymentOperation.getPrefData() ?? _paymentOperations[0];

    _paymentOptions = {
      "show_billing": (await keyShowBilling.getPrefData() == "true"),
      "show_shipping": (await keyShowShipping.getPrefData() == "true"),
      "show_save_card": (await keyShowSaveCard.getPrefData() == "true"),
    };

    _merchantKeyController.text = 'f7bdf1db-f67e-409b-8fe7-f7ecf9634f70';
    _merchantPasswordController.text = '0c9b36c1-3410-4b96-878a-dbd54ace4e9a';
    _currencyController.text = 'EGP';
    _callbackUrlController.text = await keyCallbackUrl.getPrefData() ?? "";
    _paymentIntentIdController.text =
        await keyPaymentIntentId.getPrefData() ?? "";
    _merchantReferenceIdController.text =
        await keyMerchantRefId.getPrefData() ?? "";
    _customerEmailController.text = await keyCustomerEmail.getPrefData() ?? "";

    _billingCity = await keyBillingCity.getPrefData() ?? "";
    _billingStreet = await keyBillingStreet.getPrefData() ?? "";
    _billingCountryCode = await keyBillingCountryCode.getPrefData() ?? "";
    _billingPostalCode = await keyBillingPostalCode.getPrefData() ?? "";

    _shippingCity = await keyShippingCity.getPrefData() ?? "";
    _shippingStreet = await keyShippingStreet.getPrefData() ?? "";
    _shippingCountryCode = await keyShippingCountryCode.getPrefData() ?? "";
    _shippingPostalCode = await keyShippingPostalCode.getPrefData() ?? "";

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
          _environmentWidget('Preprod', 'Prod', _environment, (type) {
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
          _environmentWidget('English', 'Arabic', _language, (type) {
            setState(() {
              _language = type;
            });
            (type == "English" ? "EN" : "AR").addPrefData(keySdkLanguage);
          }),
          _paymentDetailWidget(),
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
          _addressFormWidget(true),
          _verticalSizeBox,
          Text(
            "Shipping address",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _verticalSizeBox,
          _addressFormWidget(false),
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

  Widget _environmentWidget(String title1, String title2, String selectedTitle,
      Function(String selection) onClick) {
    return Row(
      children: [
        InkWell(
          onTap: () => onClick(title1),
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: (selectedTitle == title1)
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                    color:
                        (selectedTitle == title1) ? Colors.blue : Colors.grey,
                    width: 1),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0))),
            child: Text(
              title1.toUpperCase(),
              style: TextStyle(
                color: (selectedTitle == title1) ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onClick(title2),
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: (selectedTitle == title2)
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                    color:
                        (selectedTitle == title2) ? Colors.blue : Colors.grey,
                    width: 1),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0))),
            child: Text(
              title2.toUpperCase(),
              style: TextStyle(
                color: (selectedTitle == title2) ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
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

  Widget _paymentDetailWidget() {
    return Column(
      children: [
        _verticalSizeBox,
        Text(
          "Payment Details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _verticalSizeBox,
        TextFormField(
          controller: _currencyController,
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
          controller: _callbackUrlController,
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
          controller: _paymentIntentIdController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Payment intent ID",
            counterText: "",
          ),
        ),
        /*
        _verticalSizeBox,
        DropdownButtonFormField2(
          decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(),
            labelText: "Theme",
            counterText: "",
          ),
          isExpanded: true,
          items: _themeOptions
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select theme.';
            }
            return null;
          },
          onChanged: (value) {
            value.addPrefData(keyTheme);
          },
          onSaved: (value) {
            value.addPrefData(keyTheme);
          },
          value: _savedTheme,
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
            ),
            iconSize: 30,
          ),
        ),*/
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
                value: _paymentOptions["show_billing"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _paymentOptions["show_billing"] = value ?? false;
                  });
                  value.addPrefData(keyShowBilling);
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Show Shipping"),
                value: _paymentOptions["show_shipping"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _paymentOptions["show_shipping"] = value ?? false;
                  });
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
                value: _paymentOptions["show_save_card"],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _paymentOptions["show_save_card"] = value ?? false;
                  });
                  value.addPrefData(keyShowSaveCard);
                },
              ),
            ),
          ],
        ),
        _verticalSizeBox,
        TextFormField(
          controller: _merchantReferenceIdController,
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
        _dropDownWidget("Payment Operation", _savedPaymentOpration,
            _paymentOperations, keyPaymentOperation),
        /*_verticalSizeBox,
        _dropDownWidget(
            "Initiated By", _savedInitiatedItem, _initiatedItem, keyInitiated),*/
      ],
    );
  }

  Widget _dropDownWidget(
      String hint, String initialValue, List<String> items, String keyPref) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: const OutlineInputBorder(),
        labelText: hint,
        counterText: "",
      ),
      isExpanded: true,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select connectivity.';
        }
        return null;
      },
      onChanged: (value) {
        value.addPrefData(keyPref);
      },
      onSaved: (value) {
        value.addPrefData(keyPref);
      },
      value: initialValue,
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 30,
      ),
    );
  }

  Widget _addressFormWidget(bool isBilling) {
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
            initialValue: isBilling ? _billingCity : _shippingCity,
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
            initialValue: isBilling ? _billingStreet : _shippingStreet,
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
                  initialValue:
                      isBilling ? _billingCountryCode : _shippingCountryCode,
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
                  initialValue:
                      isBilling ? _billingPostalCode : _shippingPostalCode,
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
