import './weight.dart';
import './height.dart';
import './head.dart';
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
      case 'boyHeight':
        _t = {"max": boyWMax, "min": boyWMix};
        break;
      case 'girlHeight':
        _t = {"max": girlWMax, "min": girlWMix};
        break;
      case 'boyWeight':
        _t = {"max": boyHMax, "min": boyHMix};
        break;
      case 'girlWeight':
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
