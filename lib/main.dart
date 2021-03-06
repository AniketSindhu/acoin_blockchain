import 'package:acoin_blockchain/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var myData;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        'https://rinkeby.infura.io/v3/79a71b288cea4e2ea6e41389d8c7b46f',
        httpClient);
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x9704e539D741e5C59E29FaFBe6b4Ab271bd68FC1";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "Acoin"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalnce",[]);

    myData=result[0];
    data=true;
    setState(() {
    });
  }

  Future<String> submit(String functionName, List<dynamic> args)async{
    EthPrivateKey credential =EthPrivateKey.fromHex("2d0b3dd23b10339a1791f4cdc82602029db757c031191bef9b0652474892a2b7");

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(credential, Transaction.callContract(contract: contract, function: ethFunction, parameters: args),fetchChainIdFromNetworkId: true);

    return result;
  }

  Future<String> depositBalance() async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    var bigAmount = BigInt.from(amount);
    var response = await submit("depositBalance",[bigAmount]);
    print("Deposited");

    return response;
  }

  Future<String> withdrawBalance() async {
    //EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    var bigAmount = BigInt.from(amount);
    var response = await submit("withdrawBalance",[bigAmount]);
    print("Withdrawn");

    return response;
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
                  ? "\$$myData".text.bold.xl6.makeCentered().shimmer()
                  : CircularProgressIndicator().centered()
            ]))
                .p16
                .white
                .size(context.screenWidth, context.percentHeight * 20)
                .rounded
                .shadowXl
                .make()
                .p16(),
            30.heightBox,
            SliderWidget(
              min: 0,
              max: 100,
              finalVal: (val) {
                amount = (val * 100).round();
              },
            ).centered(),
            HStack(
              [
                FlatButton.icon(
                        onPressed: ()=>getBalance(myAddress),
                        color: Colors.blue,
                        shape: Vx.roundedSm,
                        icon: Icon(Icons.refresh, color: Colors.white),
                        label: "Refresh".text.white.make())
                    .h(50),
                FlatButton.icon(
                        onPressed: ()=>depositBalance(),
                        color: Colors.green,
                        shape: Vx.roundedSm,
                        icon:
                            Icon(Icons.call_made_outlined, color: Colors.white),
                        label: "Deposit".text.white.make())
                    .h(50),
                FlatButton.icon(
                        onPressed: ()=>withdrawBalance(),
                        color: Colors.red,
                        shape: Vx.roundedSm,
                        icon: Icon(Icons.call_received, color: Colors.white),
                        label: "Withdraw".text.white.make())
                    .h(50),
              ],
              alignment: MainAxisAlignment.spaceAround,
              axisSize: MainAxisSize.max,
            ).p16()
          ])
        ]));
  }
}
