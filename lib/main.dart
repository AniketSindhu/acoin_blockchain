import 'package:acoin_blockchain/slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Blockchain Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ACoin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client httpClient;
  Web3Client ethClient;
  bool data = false;
  int amount = 0;
  final myAddress = "0x830748d372c6C6BEBb5BF122f6803f9868fe6c93";

  @override
  void initState(){
    super.initState();
    httpClient = Client();
    ethClient = Web3Client('https://rinkeby.infura.io/v3/79a71b288cea4e2ea6e41389d8c7b46f', httpClient);
    getBalance(myAddress);
  }

  Future<void> getBalance(String targetAddress) async{
    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Vx.gray300,
        body: ZStack([
          VxBox()
              .blue600
              .size(context.screenWidth, context.percentHeight * 30)
              .make(),
          VStack([
            (context.percentHeight * 10).heightBox,
            "\$ACOIN".text.xl4.white.bold.center.makeCentered().py16(),
            (context.percentHeight * 5).heightBox,
            VxBox(
                    child: VStack([
              "Balance".text.gray700.xl2.semiBold.makeCentered(),
              10.heightBox,
              data
                  ? "\$1".text.bold.xl6.makeCentered()
                  : CircularProgressIndicator().centered()
            ]))
                .p16
                .white
                .size(context.screenWidth, context.percentHeight * 18)
                .rounded
                .shadowXl
                .make()
                .p16(),
            30.heightBox,

            SliderWidget(
              min:0,
              max:100,
              finalVal: (val){
                amount= (val*100).round();
              },
              ).centered(),

            HStack(
              [
                FlatButton.icon(
                    onPressed: () {},
                    color: Colors.blue,
                    shape: Vx.roundedSm,
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: "Refresh".text.white.make()).h(50),
                FlatButton.icon(
                    onPressed: () {},
                    color: Colors.green,
                    shape: Vx.roundedSm,
                    icon: Icon(Icons.call_made_outlined, color: Colors.white),
                    label: "Deposit".text.white.make()).h(50),
                FlatButton.icon(
                    onPressed: () {},
                    color: Colors.red,
                    shape: Vx.roundedSm,
                    icon:
                        Icon(Icons.call_received, color: Colors.white),
                    label: "Withdraw".text.white.make()).h(50),
              ],
              alignment: MainAxisAlignment.spaceAround,
              axisSize: MainAxisSize.max,
            ).p16()
          ])
        ]));
  }
}
