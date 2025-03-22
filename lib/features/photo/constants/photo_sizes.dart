class PhotoSizes {
  // 中国标准
  static const oneInch = (width: 295, height: 413);     // 一寸
  static const twoInch = (width: 413, height: 579);     // 二寸
  static const idPhoto = (width: 358, height: 441);     // 身份证/护照

  // 日本标准
  static const residenceCard = (width: 300, height: 400);  // 在留卡
  static const passportJP = (width: 450, height: 450);     // 日本护照
  static const drivingLicenseJP = (width: 240, height: 320);  // 日本驾照

  // 国际标准
  static const schengenVisa = (width: 350, height: 450);   // 申根签证
  static const usVisa = (width: 600, height: 600);         // 美国签证
}