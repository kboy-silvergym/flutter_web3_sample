import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const kboyAddress = '0x4BD1D324F124907AB59DCD9fFdF7146Ff4242Ecf';

class _MyHomePageState extends State<MyHomePage> {
  String account = '';
  double balanceString = 0;

  void _fetchBalance() async {
    print(ethereum);
    // `Ethereum.isSupported` is the same as `ethereum != null`
    if (ethereum != null) {
      try {
        // Prompt user to connect to the provider, i.e. confirm the connection modal
        final accounts = await ethereum!.requestAccount();
        final firstAccount = accounts.first;

        final BigInt balance = await provider!.getBalance(kboyAddress);
        final ethBalance =
            balance.toDouble() * 1 / 1000000000000000000; // WEI to ETH

        setState(() {
          account = firstAccount;
          balanceString = ethBalance;
        });
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Web3 Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Address: $account',
            ),
            Text(
              '$balanceString ETH',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () async {
                  // Send 1000000000 wei to `0xcorge`
                  final tx = await provider!.getSigner().sendTransaction(
                        TransactionRequest(
                          to: kboyAddress,
                          value: BigInt.from(1000000000000),
                        ),
                      );
                  final receipt = await tx.wait();
                  print(receipt);
                },
                child: const Text('send')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchBalance,
        child: const Icon(Icons.account_balance_wallet),
      ),
    );
  }
}
