import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends StatefulWidget {
  const RazorPay({Key? key}) : super(key: key);

  @override
  _RazorPayState createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  late Razorpay razorpay;
  TextEditingController amtCnrt = TextEditingController();

  void openCheckout(amt) async {
    amt = amt * 1;
    var opts = {
      'key': 'cust_NmsrrgFGOPMYp9',
      'amount': amt,
      'name': 'Marky',
      'profile': {
        'contact': '9995967899',
        'email': 'leroyjeslyn@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      }
    };
    try {
      razorpay.open(opts);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  void handlePaySucess(PaymentSuccessResponse res) {
    Fluttertoast.showToast(
        msg: "Success ${res.paymentId!}", toastLength: Toast.LENGTH_SHORT);
  }

  void handlePayErr(PaymentFailureResponse res) {
    Fluttertoast.showToast(
        msg: "Failed ${res.message!}", toastLength: Toast.LENGTH_SHORT);
  }

  void handleExtWallet(ExternalWalletResponse res) {
    Fluttertoast.showToast(
        msg: "Wallet ${res.walletName!}", toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaySucess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePayErr);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExtWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome",
            style: TextStyle(
              color: Colors.grey.shade100,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: Colors.lime,
              autofocus: false,
              style: TextStyle(color: Colors.amber.shade100),
              decoration: InputDecoration(
                  labelText: "Pay",
                  labelStyle:
                      TextStyle(fontSize: 15.0, color: Colors.amber.shade100),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blueGrey.shade400,
                    width: 1.0,
                  )),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15)),
              controller: amtCnrt,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Please Enter Amount";
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              if (amtCnrt.text.toString().isNotEmpty) {
                setState(() {
                  int amt = int.parse(amtCnrt.text.toString());
                  openCheckout(amt);
                });
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Payyy"),
            ),
          ),
        ])));
  }
}
