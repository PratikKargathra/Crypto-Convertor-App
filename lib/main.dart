import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context) => const Homepage(),
      },
    );
  }
}

bool isIOS = false;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<String> currency = <String>[
    "USD",
    "INR",
    "JPY",
    "EUR",
    "AUD",
    "BRL",
    "CAD",
    "CNY",
    "NZD",
  ];

  List<String> cryptoCurrency = <String>[
    "BTC",
    "ETH",
  ];

  String selectedCurrency = "INR";
  String baseUrl = "https://free.currconv.com/api/v7/convert?q=";
  String endpoint = "&compact=ultra&apiKey=";
  String apiKey = "3b5660c13f7fcd228a84"; //"ff551fb88f27d2137f02";
  String selectedCrypto = "BTC";

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    setState(() {});
    setCurrencyValue();
    Timer.periodic(const Duration(milliseconds: 100), (t){setState(() {});});
  }

  setCurrencyValue() async {
    cryptoCurrency.forEach((element) async {
      currencyValue[cryptoCurrency.indexOf(element)] = await getCurrencyValue(cryptoCurrency[cryptoCurrency.indexOf(element)]);
    });
    setState(() {});
  }

  List currencyValue = [
    "0",
    "0",
  ];

  getCurrencyValue(String cryptoName) async  {
    Uri api = Uri.parse(baseUrl+cryptoName+"_"+selectedCurrency+endpoint+apiKey);
    http.Response response = await http.get(api);
    if(response.statusCode == 200){
      Map<String, dynamic> data = await jsonDecode(response.body);
      return "${await data[cryptoName+"_"+selectedCurrency]}" ;
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if ((isIOS)) {
      return CupertinoPageScaffold(
          navigationBar:  CupertinoNavigationBar(
            trailing: CupertinoSwitch(
                activeColor: Colors.white,
                thumbColor: const Color(0xFF746AB0),
                value: isIOS,
                onChanged: (val){setState(() {isIOS = val;});}),


            backgroundColor: const Color(0xFF746AB0),
            middle: const Text("CRYPTO CONVERTOR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20, letterSpacing: 3),),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 12,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: cryptoCurrency.map((e) =>  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height*0.1,
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: BoxDecoration(
                        color: const Color(0xff746AB0),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0,0),
                          ),
                        ]
                    ),
                    child: Text("1 $e = ${currencyValue[cryptoCurrency.indexOf(e)]} $selectedCurrency", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500,decoration: TextDecoration.none ), ),
                  ),).toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF746AB0),
                  child: CupertinoPicker(
                    children: currency.map((e) => Text(e, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),)).toList(),
                    onSelectedItemChanged: (val){
                      setState(() {
                        selectedCurrency = currency[val];
                        setCurrencyValue();
                      });
                    }, itemExtent: 30,
                  ),
                ),
              )
            ],
          )
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Switch(value: isIOS, onChanged: (val){
              setState(() {
                isIOS= val;
              });
            }),
          ],
          title: const Text("CRYPTO CONVERTOR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20, letterSpacing: 3),),
          backgroundColor: const Color(0xff746AB0),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: cryptoCurrency.map((e) =>  Container(
            alignment: Alignment.center,
            child: Text("1 $e = ${currencyValue[cryptoCurrency.indexOf(e)]} $selectedCurrency", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, ),),
            margin: const EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width*0.8,
            decoration: BoxDecoration(
                color: const Color(0xff746AB0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0,0),
                  ),
                ]
            ),
          ),).toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Current Currency", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
              DropdownButton(
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,),
                  dropdownColor: const Color(0xff746AB0),

                  value: selectedCurrency,

                  items: currency.map((e) =>
                      DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      )).toList(),
                  onChanged: (String? val){
                    setState(() {
                      selectedCurrency = val!;
                      setCurrencyValue();
                    });
                  }
              ),
            ],
          ),
          height: 80,
          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(
              color: const Color(0xff746AB0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0,0),
                ),
              ]
          ),
        ),
      );
    }
  }
}

