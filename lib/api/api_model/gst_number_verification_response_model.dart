// To parse this JSON data, do
//
//     final gstVerificationModel = gstVerificationModelFromJson(jsonString);

import 'dart:convert';

GstVerificationModel gstVerificationModelFromJson(String str) => GstVerificationModel.fromJson(json.decode(str));

String gstVerificationModelToJson(GstVerificationModel data) => json.encode(data.toJson());

class GstVerificationModel {
  GstVerificationModel({
    required this.flag,
    required this.message,
    required this.data,
  });

  bool flag;
  String message;
  Data data;

  factory GstVerificationModel.fromJson(dynamic json) => GstVerificationModel(
    flag: json["flag"]!,
    message: json["message"]!,
    data: Data.fromJson(json["data"]!),
  );

  dynamic toJson() => {
    "flag": flag,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.ntcrbs,
    required this.adhrVFlag,
    required this.lgnm,
    required this.stj,
    required this.dty,
    required this.cxdt,
    required this.gstin,
    required this.nba,
    required this.ekycVFlag,
    required this.cmpRt,
    required this.rgdt,
    required this.ctb,
    required this.pradr,
    required this.sts,
    required this.tradeNam,
    required this.isFieldVisitConducted,
    required this.adhrVdt,
    required this.ctj,
    required this.einvoiceStatus,
    required this.lstupdt,
    required this.adadr,
    required this.ctjCd,
    this.errorMsg,
    required this.stjCd,
  });

  String ntcrbs;
  String adhrVFlag;
  String lgnm;
  String stj;
  String dty;
  String cxdt;
  String gstin;
  List<String> nba;
  String ekycVFlag;
  String cmpRt;
  String rgdt;
  String ctb;
  Pradr pradr;
  String sts;
  String tradeNam;
  String isFieldVisitConducted;
  String adhrVdt;
  String ctj;
  String einvoiceStatus;
  String lstupdt;
  List<dynamic> adadr;
  String ctjCd;
  dynamic errorMsg;
  String stjCd;

  factory Data.fromJson(dynamic json) => Data(
    ntcrbs: json["ntcrbs"]!,
    adhrVFlag: json["adhrVFlag"]!,
    lgnm: json["lgnm"]!,
    stj: json["stj"]!,
    dty: json["dty"]!,
    cxdt: json["cxdt"]!,
    gstin: json["gstin"]!,
    nba: List<String>.from(json["nba"]!.map((x) => x)),
    ekycVFlag: json["ekycVFlag"]!,
    cmpRt: json["cmpRt"]!,
    rgdt: json["rgdt"]!,
    ctb: json["ctb"]!,
    pradr: Pradr.fromJson(json["pradr"]!),
    sts: json["sts"]!,
    tradeNam: json["tradeNam"]!,
    isFieldVisitConducted: json["isFieldVisitConducted"]!,
    adhrVdt: json["adhrVdt"]!,
    ctj: json["ctj"]!,
    einvoiceStatus: json["einvoiceStatus"]!,
    lstupdt: json["lstupdt"]!,
    adadr: List<dynamic>.from(json["adadr"]!.map((x) => x)),
    ctjCd: json["ctjCd"]!,
    errorMsg: json["errorMsg"]!,
    stjCd: json["stjCd"]!,
  );

  dynamic toJson() => {
    "ntcrbs": ntcrbs,
    "adhrVFlag": adhrVFlag,
    "lgnm": lgnm,
    "stj": stj,
    "dty": dty,
    "cxdt": cxdt,
    "gstin": gstin,
    "nba": List<dynamic>.from(nba.map((x) => x)),
    "ekycVFlag": ekycVFlag,
    "cmpRt": cmpRt,
    "rgdt": rgdt,
    "ctb": ctb,
    "pradr": pradr.toJson(),
    "sts": sts,
    "tradeNam": tradeNam,
    "isFieldVisitConducted": isFieldVisitConducted,
    "adhrVdt": adhrVdt,
    "ctj": ctj,
    "einvoiceStatus": einvoiceStatus,
    "lstupdt": lstupdt,
    "adadr": List<dynamic>.from(adadr.map((x) => x)),
    "ctjCd": ctjCd,
    "errorMsg": errorMsg,
    "stjCd": stjCd,
  };
}

class Pradr {
  Pradr({
    required this.adr,
    required this.addr,
  });

  String adr;
  Addr addr;

  factory Pradr.fromJson(dynamic json) => Pradr(
    adr: json["adr"]!,
    addr: Addr.fromJson(json["addr"]!),
  );

  dynamic toJson() => {
    "adr": adr,
    "addr": addr.toJson(),
  };
}

class Addr {
  Addr({
    required this.flno,
    required this.lg,
    required this.loc,
    required this.pncd,
    required this.bnm,
    required this.city,
    required this.lt,
    required this.stcd,
    required this.bno,
    required this.dst,
    required this.st,
  });

  String flno;
  String lg;
  String loc;
  String pncd;
  String bnm;
  String city;
  String lt;
  String stcd;
  String bno;
  String dst;
  String st;

  factory Addr.fromJson(dynamic json) => Addr(
    flno: json["flno"]!,
    lg: json["lg"]!,
    loc: json["loc"]!,
    pncd: json["pncd"]!,
    bnm: json["bnm"]!,
    city: json["city"]!,
    lt: json["lt"]!,
    stcd: json["stcd"]!,
    bno: json["bno"]!,
    dst: json["dst"]!,
    st: json["st"]!,
  );

 dynamic toJson() => {
    "flno": flno,
    "lg": lg,
    "loc": loc,
    "pncd": pncd,
    "bnm": bnm,
    "city": city,
    "lt": lt,
    "stcd": stcd,
    "bno": bno,
    "dst": dst,
    "st": st,
  };
}
