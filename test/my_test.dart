import 'package:alan/alan.dart';
import 'package:alan/utils/environment.dart';
import 'package:test/test.dart';
import 'package:alan/proto/cosmos/bank/v1beta1/export.dart' as bank;

void main () {
  test('Testing hello', () async {
    final networkInfo = NetworkInfo(
      bech32Hrp: 'cosmos',
      fullNodeHost: 'localhost',
      env: Environment.DEV,
    );

    final mnemonicString =
        'arrest early remember expect lumber furnace extra shrimp glass vacuum sea wreck satisfy puppy wrestle hedgehog addict coil give survey improve lemon output helmet';
    final mnemonic = mnemonicString.split(' ');
    final wallet = Wallet.derive(mnemonic, networkInfo);

    // 3. Create and sign the transaction
    final message = bank.MsgSend.create()
      ..fromAddress = wallet.bech32Address
      ..toAddress = 'cosmos19agnq4nn7x77f0m6jhasj59cdudrgge89zkgvz';
    message.amount.add(Coin.create()
      ..denom = 'token'
      ..amount = '10');

    final signer = TxSigner.fromNetworkInfo(networkInfo);
    final tx = await signer.createAndSign(wallet, [message]);

    // 4. Broadcast the transaction
    final txSender = TxSender.fromNetworkInfo(networkInfo);
    final response = await txSender.broadcastTx(tx);

    // Check the result
    if (response.isSuccessful) {
      print('Tx sent successfully. Response: ${response}');
    } else {
      print('Tx errored: ${response}');
    }
  });
}