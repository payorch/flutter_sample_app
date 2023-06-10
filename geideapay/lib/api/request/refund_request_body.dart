import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';
import 'package:geideapay/common/card_utils.dart';

class RefundRequestBody extends PostPayOperationRequestBody {
  String? callbackUrl_;
  RefundRequestBody(String orderId, {this.callbackUrl_}):
        super(orderId, callbackUrl: callbackUrl_);
}
