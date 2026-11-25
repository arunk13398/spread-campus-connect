import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';




class DemoTest extends StatefulWidget {
  DemoTest({Key? key}) : super(key: key);

  @override
  State<DemoTest> createState() => _DemoTestState();
}

class _DemoTestState extends State<DemoTest> {
  final List<String> _dogeNames = [
    'Beagle',
    'Labrador',
    'Retriever',
  ];

  final List<String> _menuItems = [
    'All',
    'Students',
    'Teachers',
    'Non Teaching-Staff',
    'Events',
    'Events',
    'Other college',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chip List Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Using [supportsMultiSelect]
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Using supportsMultiSelect - using border colors and text color',
            ),
            const SizedBox(
              height: 10,
            ),
            ChipList(
              listOfChipNames: _dogeNames,
              supportsMultiSelect: true,
              activeBgColorList: const [Colors.white],
              inactiveBgColorList: const [Colors.white],
              activeTextColorList: const [
                Colors.pink,
                Colors.yellow,
                Colors.green
              ],
              inactiveTextColorList: [Theme.of(context).primaryColor],
              listOfChipIndicesCurrentlySelected: [0],
              inactiveBorderColorList: const [Colors.white],
              activeBorderColorList: const [
                Colors.pink,
                Colors.yellow,
                Colors.green
              ],
            ),

            // Using [supportsMultiSelect]
            const SizedBox(
              height: 20,
            ),
            const Text('Using supportsMultiSelect'),
            const SizedBox(
              height: 10,
            ),
            ChipList(
              listOfChipNames: _dogeNames,
              supportsMultiSelect: true,
              activeBgColorList: const [Colors.pink, Colors.yellow, Colors.green],
              inactiveBgColorList: const [Colors.white],
              activeTextColorList: const [Colors.white],
              inactiveTextColorList: [Theme.of(context).primaryColor],
              listOfChipIndicesCurrentlySelected: [0],
              inactiveBorderColorList: const [
                Colors.pink,
                Colors.yellow,
                Colors.green
              ],
              activeBorderColorList: const [
                Colors.pink,
                Colors.yellow,
                Colors.green
              ],
            ),

            // Using [extraOnToggle]
            const SizedBox(
              height: 20,
            ),
            Text('Using extraOnToggle: ${_menuItems[_currentIndex]}'),
            const SizedBox(
              height: 10,
            ),
            ChipList(
              listOfChipNames: _menuItems,
              // activeBgColorList: [Theme.of(context).primaryColor],
              activeBgColorList: [Theme.of(context).primaryColor],
              inactiveBgColorList: const [Colors.white],
              activeTextColorList: const [Colors.white],
              inactiveTextColorList: [Theme.of(context).primaryColor],
              listOfChipIndicesCurrentlySelected: [_currentIndex],
              inactiveBorderColorList:  [Colors.grey.shade300],
              extraOnToggle: (val) {
                _currentIndex = val;
                setState(() {});
              },
            ),
            // Using [shouldWrap]

          ],
        ),
      ),
    );
  }
}