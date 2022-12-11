import 'package:firebase_database/firebase_database.dart';

class BankInfoModel {
  String? accountName;
  String? accountNumber;
  String? bankName;

  BankInfoModel({
    this.accountName,
    this.accountNumber,
    this.bankName,
  });

  BankInfoModel.fromSnapshot(DataSnapshot snapshot) {
    accountNumber = (snapshot.value as dynamic)["account_number"];
    accountName = (snapshot.value as dynamic)["account_name"];
    bankName = (snapshot.value as dynamic)["bank_name"];
  }
}
