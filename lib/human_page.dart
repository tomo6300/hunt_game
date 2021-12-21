import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hunt_game/human_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HumanPage extends StatefulWidget {
  HumanPage({Key? key}) : super(key: key);

  @override
  State<HumanPage> createState() => _HumanPageState();
}

class _HumanPageState extends State<HumanPage> {
  final int plantCost = 5;
  final int revenue = 8;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final List<int> _items = List.generate(22, (i) => i);
  int _selectedSquareForTrap = 0;
  int _selectedSquareForCropsField = 0;

  HumanState humanState = HumanState([-1, -1, -1], [-1, -1, -1], 30);

  void _setter(List list, int _selectedSquare) {
    for (var i = 0; i < 3; i++) {
      if (list[i] == -1) {
        list[i] = _selectedSquare;
        break;
      }
    }
  }

  void _resetter(List list, int itemNum) {
    list[itemNum] = -1;
  }

  Future<void> _trapSetter(traps) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _setter(traps, _selectedSquareForTrap);
    });
    List<String> sTraps = ["-1", "-1", "-1"];
    for (int i = 0; i < traps.length; i++) {
      sTraps[i] = traps[i].toString();
    }
    await prefs.setStringList('traps', sTraps);
  }

  Future<void> _cropsFieldsSetter(cropsFields) async {
    setState(() {
      _setter(cropsFields, _selectedSquareForCropsField);
    });
    _cropsFieldsIntToString(cropsFields);
    _minusMoney(plantCost);
  }

  Future<void> _cropsFieldsResetter(cropsFields, itemNum) async {
    setState(() {
      _resetter(cropsFields, itemNum);
    });
    _cropsFieldsIntToString(cropsFields);
  }

  Future<void> _cropsFieldsIntToString(cropsFields) async {
    final SharedPreferences prefs = await _prefs;
    List<String> sCropsFields = ["-1", "-1", "-1"];
    for (int i = 0; i < cropsFields.length; i++) {
      sCropsFields[i] = cropsFields[i].toString();
    }
    await prefs.setStringList('cropsFields', sCropsFields);
  }

  Future<void> _harvest(itemNum) async {
    _cropsFieldsResetter(humanState.cropsFields, itemNum);
    _plusMoney(revenue);
  }

  Future<void> _plusMoney(int cost) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      humanState.money += cost;
    });
    await prefs.setInt('money', humanState.money);
  }

  Future<void> _minusMoney(int cost) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      humanState.money -= cost;
    });
    await prefs.setInt('money', humanState.money);
  }

  Future<List?> _getTraps() async {
    SharedPreferences prefs = await _prefs;
    return ((prefs.getStringList('traps') ?? humanState.traps.cast<String>())
        .map((data) => int.parse(data))
        .toList());
  }

  Future<List?> _getCropsFields() async {
    SharedPreferences prefs = await _prefs;
    return ((prefs.getStringList('cropsFields') ??
            humanState.cropsFields.cast<String>())
        .map((data) => int.parse(data))
        .toList());
  }

  Future<int?> _getMoney() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getInt('money');
  }

  Future<void> _resetPrefItems() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      humanState.traps = [-1, -1, -1];
      humanState.cropsFields = [-1, -1, -1];
      humanState.money = 30;
    });
    await prefs.setStringList('traps', ["-1", "-1", "-1"]);
    await prefs.setStringList('cropsFields', ["-1", "-1", "-1"]);
    await prefs.setInt('money', humanState.money);
  }

  @override
  void initState() {
    super.initState();
    _getTraps().then((value) {
      setState(() {
        humanState.traps = value!.cast<int>();
      });
    });
    _getCropsFields().then((value) {
      setState(() {
        humanState.cropsFields = value!.cast<int>();
      });
    });
    _getMoney().then((value) {
      setState(() {
        humanState.money = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "猟師",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "罠",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  DropdownButton<int>(
                    value: _selectedSquareForTrap,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSquareForTrap = newValue!;
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
                          style: item == _selectedSquareForTrap
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _trapSetter(humanState.traps);
                      },
                      child: const Text("設置"))
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
                        "罠a",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.traps[0].toString(),
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        "罠b",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.traps[1].toString(),
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        "罠c",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.traps[2].toString(),
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                "農家",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "田畑",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  DropdownButton<int>(
                    value: _selectedSquareForCropsField,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSquareForCropsField = newValue!;
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
                          style: item == _selectedSquareForCropsField
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _cropsFieldsSetter(humanState.cropsFields);
                      },
                      child: const Text("設置"))
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
                        "畑a",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.cropsFields[0].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _harvest(0);
                          },
                          child: const Text("収穫"))
                    ],
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        "畑b",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.cropsFields[1].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _harvest(1);
                          },
                          child: const Text("収穫"))
                    ],
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Column(
                    children: [
                      const Text(
                        "畑c",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        humanState.cropsFields[2].toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _harvest(2);
                          },
                          child: const Text("収穫"))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "お金",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _minusMoney(1);
                      },
                      child: const Text("-")),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    humanState.money.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _plusMoney(1);
                      },
                      child: const Text("+"))
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    _resetPrefItems();
                  },
                  child: const Text("リセット"))
            ],
          ),
        ),
      ),
    );
  }
}
