# Geidea Online Payments for Android Mobile Apps

 - Contributors: kanti-kiran 
 - Keywords: credit card, geidea, payment, payment for mobile sdk, payment for android, payment request, android
 - License: GPLv3
 - License URI: https://www.gnu.org/licenses/gpl-3.0.html

Add the Geidea online payments SDK to your mobile app store with Low Code and start accepting online payments seamlessly with Geidea Payment Gateway. Geidea Online Payments SDK for Android provides you with the required tools for quick and easy integration of Geidea Payment Gateway services into your Android app.

## Requirements
- dart: ">=3.0.3 <4.0.0"

### Getting Started

The Package is available on GitHub.

1. In your `pubspec.yaml` file add:
```
dependencies:
  geideapay:
    git:
      url: https://github.com/payorch/flutter_sdk.git
      ref: main # branch name

```

2. `flutter pub get` run this command for add above package in your project.

3. Then, in your code import:

```
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';

```

### Usage

The integration starts by adding your merchant credentials (Merchant Public Key and API password) with the `GeideapayPlugin.initialize()`method.

```
final _plugin = GeideapayPlugin();

@override
void initState() {
	super.initState();
	_plugin.initialize(publicKey: "<YOUR MERCHANT KEY>",apiPassword: "<YOUR MERCHANT PASSWORD>");
}

```

IMPORTANT: 
1. The ```initialize()``` method is used for set credentials on plugin. This method or plugin not storing your credentials in any way. So it is required to set them on each app start event or before ```checkout()```.
2. As a good security and coding practice, do **not** hard-code your merchant password directly into your code file. Always get it securely and dynamically (from the secure endpoint of your backend or some secure server) where the password has been stored with encryption.

### Building your CheckoutOptions

```
Address billingAddress = Address(
	city: "Riyadh",
	countryCode: "SAU",
	street: "Street 1",
	postCode: "1000");
Address shippingAddress = Address(
	city: "Riyadh",
	countryCode: "SAU",
	street: "Street 1",
	postCode: "1000");

CheckoutOptions checkoutOptions = CheckoutOptions(
	"123.45",
	"SAR",
    callbackUrl: "https://website.hook/", //Optional
    lang: "AR", //Optional
    billingAddress: billingAddress, //Optional
    shippingAddress: shippingAddress, //Optional
    customerEmail: "email@noreply.test", //Optional
    merchantReferenceID: "1234", //Optional
    paymentIntentId: null, //Optional
    paymentOperation: "Pay", //Optional
    showAddress: true, //Optional
    showEmail: true, //Optional
    textColor: "#ffffff", //Optional
    cardColor: "#ff4d00", //Optional
    payButtonColor: "#ff4d00", //Optional
    cancelButtonColor: "#878787", //Optional
    backgroundColor: "#2c2222", //Optional
);

```

### Call `checkout` method to open payment screen

```
try {
	OrderApiResponse response = await _plugin.checkout(context: context, checkoutOptions: checkoutOptions);
	debugPrint('Response = $response');

	// Payment successful, order returned in response
	_updateStatus(response.detailedResponseMessage, truncate(response.toString()));
} catch (e) {
	debugPrint("OrderApiResponse Error: $e");
	// An unexpected error due to improper SDK
	// integration or Plugin internal bug
	 _showMessage(e.toString());
}

```
