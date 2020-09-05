class PaymentMethodModel {

  String paymentAccountNumber ;
  int paymentId ;

  static fromJson(Map<String,dynamic> paymentMethod){
    List<PaymentMethodModel> paymentMethods = List();

    if(paymentMethod.containsKey('postAccountNumber')){
      paymentMethods.add(PaymentMethodModel(
        paymentAccountNumber: paymentMethod['postAccountNumber'],
        paymentId: 0,
      ));
    }

    if(paymentMethod.containsKey('vfAccountNumber')){
      paymentMethods.add(PaymentMethodModel(
        paymentAccountNumber: paymentMethod['vfAccountNumber'],
        paymentId: 1,
      ));
    }



  }

  PaymentMethodModel({this.paymentId , this.paymentAccountNumber});



}