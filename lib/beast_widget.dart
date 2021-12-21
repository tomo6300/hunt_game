/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'beast_state.dart';

class BeastWidget extends StatefulWidget {
  BeastWidget(this._selectedSquareForBeast);
  int _selectedSquareForBeast;

  @override
  State<BeastWidget> createState() =>
      _BeastWidgetState(_selectedSquareForBeast);
}

class _BeastWidgetState extends State<BeastWidget> {
  _BeastWidgetState(this._selectedSquareForBeast);
  int _selectedSquareForBeast;

  final int moveCost = 1;
  final List<int> _items = List.generate(22, (i) => i);

  void _setter(List list, int _selectedSquare) {
    for (var i = 0; i < beastState.beastDestination.length; i++) {
      if (list[i] == -1) {
        list[i] = _selectedSquare;
        break;
      }
    }
  }

  Future<void> _beastLocationSetter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _setter(beastState.beastDestination, _selectedSquareForBeast);
    });
    //List<String> sBeastDestinations = beastDestination.cast<String>();
    await prefs.setStringList(
        'beastDestination', _intListToStringList(beastState.beastDestination));
  }

  Future<int> _isCropsField(int _selectedSquare) async {
    SharedPreferences prefs = await _prefs;
    var cropsFields = (prefs.getStringList('cropsFields') ??
            ["-1", "-1", "-1"].cast<String>())
        .map((data) => int.parse(data))
        .toList();

    return cropsFields.indexOf(_selectedSquare);
  }

  Future<int> _isTraps(int _selectedSquare) async {
    SharedPreferences prefs = await _prefs;
    var traps = (prefs.getStringList('traps') ?? ["-1", "-1", "-1"])
        .map((data) => int.parse(data))
        .toList();

    return traps.indexOf(_selectedSquare);
  }

  Future<void> _isFieldHasEvents() async {
    SharedPreferences prefs = await _prefs;
    var cropsFields = (prefs.getStringList('cropsFields') ?? ["-1", "-1", "-1"])
        .map((data) => (data))
        .toList();
    _isCropsField(_selectedSquareForBeast).then((value) {
      setState(() {
        if (value >= 0) {
          cropsFields[value] = "-1";
          _plusHP(3);
          event = "野菜を手に入れました";
        }
      });
    });
    await prefs.setStringList('cropsFields', cropsFields);
    var traps = (prefs.getStringList('traps') ?? ["-1", "-1", "-1"])
        .map((data) => (data))
        .toList();
    _isTraps(_selectedSquareForBeast).then((value) {
      setState(() {
        if (value >= 0) {
          traps[value] = "-1";
          _minusHP(2);
          event = "罠にハマりました";
        }
      });
    });
    await prefs.setStringList('traps', traps);
  }

  Future<void> _plusHP(int numPlus) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      beastState.hp += numPlus;
    });
    await prefs.setInt('hp', beastState.hp);
  }

  Future<void> _minusHP(int numMinus) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      beastState.hp -= numMinus;
    });
    await prefs.setInt('hp', beastState.hp);
  }

  Future<List?> _getCropsFields() async {
    SharedPreferences prefs = await _prefs;
    return ((prefs.getStringList('cropsFields') ?? ["-1", "-1", "-1"])
        .map((data) => int.parse(data))
        .toList());
  }

  Future<List?> _getCurrentBeastLocation() async {
    SharedPreferences prefs = await _prefs;
    return ((prefs.getStringList('currentBeastLocation') ??
            _intListToStringList(beastState.currentBeastLocation))
        .map((data) => int.parse(data))
        .toList());
  }

  Future<List?> _getBeastDestination() async {
    SharedPreferences prefs = await _prefs;
    return ((prefs.getStringList('beastDestination') ??
            _intListToStringList(beastState.beastDestination))
        .map((data) => int.parse(data))
        .toList());
  }

  Future<int?> _getHP() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getInt('hp');
  }

  Future<void> _beastTernEnd(int beastNumber) async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      for (var i = 0; i < beastState.beastDestination.length; i++) {
        if (beastState.beastDestination[i] == -1) {
          break;
        }
        beastState.currentBeastLocation[beastNumber] =
            beastState.beastDestination[i];
      }
      beastState.beastDestination = [-1, -1, -1];
    });
    //List<String> sCurrentBeastLocation = currentBeastLocation.cast<String>();
    await prefs.setStringList('currentBeastLocation',
        _intListToStringList(beastState.currentBeastLocation));
    await prefs.setStringList('beastDestination', ["-1", "-1", "-1"]);
  }

  Future<void> _resetPrefItems() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      beastState.currentBeastLocation = [0];
      beastState.beastDestination = [-1, -1, -1];
      beastState.hp = 30;
    });
    //List<String> sCurrentBeastLocation = currentBeastLocation.cast<String>();
    await prefs.setStringList('currentBeastLocation',
        _intListToStringList(beastState.currentBeastLocation));
    await prefs.setStringList('beastDestination', ["-1", "-1", "-1"]);
    await prefs.setInt('hp', beastState.hp);
  }

  List<String> _intListToStringList(List intList) {
    List<String> stringList = ["-1", "-1", "-1"];
    for (int i = 0; i < intList.length; i++) {
      stringList[i] = intList[i].toString();
    }
    return stringList;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentBeastLocation().then((value) {
      setState(() {
        beastState.currentBeastLocation = value!.cast<int>();
      });
    });
    _getBeastDestination().then((value) {
      setState(() {
        beastState.beastDestination = value!.cast<int>();
      });
    });
    _getHP().then((value) {
      setState(() {
        beastState.hp = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "獣1",
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "移動",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              width: 20.0,
            ),
            DropdownButton<int>(
              value: _selectedSquareForBeast,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.lightGreen,
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedSquareForBeast = newValue!;
                });
              },
              selectedItemBuilder: (context) {
                return _items.map((int item) {
                  return Text(
                    item.toString(),
                  );
                }).toList();
              },
              items: _items.map((int item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: item == _selectedSquareForBeast
                        ? const TextStyle(fontWeight: FontWeight.bold)
                        : const TextStyle(fontWeight: FontWeight.normal),
                  ),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: () {
                  _beastLocationSetter();
                  _minusHP(1);
                  _isFieldHasEvents();
                },
                child: Text("移動"))
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "現在位置",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  beastState.currentBeastLocation[0].toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              width: 30.0,
            ),
            Column(
              children: [
                const Text(
                  "移動先1",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  beastState.beastDestination[0].toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              width: 30.0,
            ),
            Column(
              children: [
                const Text(
                  "移動先2",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  beastState.beastDestination[1].toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
            const SizedBox(
              width: 30.0,
            ),
            Column(
              children: [
                const Text(
                  "移動先3",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  beastState.beastDestination[2].toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          event,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 5.0,
        ),
        ElevatedButton(
            onPressed: () {
              _beastTernEnd(0);
            },
            child: const Text("ターン終了")),
        const SizedBox(
          height: 30.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "HP",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _minusHP(1);
                },
                child: const Text("-")),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              beastState.hp.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  _plusHP(1);
                },
                child: const Text("+"))
          ],
        ),
        const SizedBox(
          height: 30.0,
        ),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}
*/
