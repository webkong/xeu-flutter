import 'package:xeu/common/constant/chart/weight.dart';
import 'package:xeu/common/constant/chart/height.dart';
import 'package:xeu/common/constant/chart/head.dart';

class BodyConstants {
  static final List boyWMax = boyWeightMax;
  static final List boyWMix = boyWeightMin;
  static final List girlWMax = girlWeightMax;
  static final List girlWMix = girlWeightMin;
  static final List boyHMax = boyHeightMax;
  static final List boyHMix = boyHeightMin;
  static final List girlHMax = girlHeightMax;
  static final List girlHMix = girlHeightMin;
  static final List boyHDMax = boyHeadMax;
  static final List boyHDMix = boyHeadMin;
  static final List girlHDMax = boyHeadMax;
  static final List girlHDMix = boyHeadMin;
  static Map getByTag(tag) {
    // tag : boyHeight boyWeight boyHead girlHeight girlWeight girlHead
    Map<String, List> _t;
    switch (tag) {
      case 'boyWeight':
        _t = {"max": boyWMax, "min": boyWMix};
        break;
      case 'girlWeight':
        _t = {"max": girlWMax, "min": girlWMix};
        break;
      case 'boyHeight':
        _t = {"max": boyHMax, "min": boyHMix};
        break;
      case 'girlHeight':
        _t = {"max": girlHMax, "min": girlHMix};
        break;
      case 'boyHead':
        _t = {"max": boyHDMax, "min": boyHDMix};
        break;
      case 'girlHead':
        _t = {"max": girlHDMax, "min": girlHDMix};
        break;
    }
    return _t;
  }
}
