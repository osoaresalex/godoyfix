import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/backend_message_mapper.dart';


class ApiChecker {
  static void checkApi(Response response, {bool showDefaultToaster = true}) {


    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData(response: response);
      if(Get.currentRoute != RouteHelper.getInitialRoute()){
        Get.offAllNamed(RouteHelper.getInitialRoute());
        customSnackBar("${response.statusCode!}".tr);
      }
    }else if(response.statusCode == 500){
      customSnackBar("${response.statusCode!}".tr, showDefaultSnackBar: showDefaultToaster);
    }
    else if(response.statusCode == 400 && response.body['errors'] !=null){
      final dynamic errors = response.body['errors'];
      String msg = '';
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        final raw = first is Map && first['message'] != null ? first['message'].toString() : '';
        msg = localizeBackendPlainMessage(raw);
      }
      customSnackBar(msg.isNotEmpty ? msg : 'bad_request'.tr, showDefaultSnackBar: showDefaultToaster);
    }
    else if(response.statusCode == 429){
      customSnackBar("too_many_request".tr, showDefaultSnackBar: showDefaultToaster);
    }
    else{
      final localized = mapResponseToLocalizedMessage(response);
      customSnackBar(localized, showDefaultSnackBar: showDefaultToaster);
    }
  }
}