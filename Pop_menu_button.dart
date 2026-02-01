import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget should be Stateless
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UnitConverterPage(),
    );
  }
}

/// Separate page widget
class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final _valueController = TextEditingController();
  final _resultController = TextEditingController();

  String? _fromUnit;
  String? _toUnit;
  double? _result;

  static const List<String> _units = [
    'Kilometer',
    'Meter',
    'Centimeter',
    'Millimeter',
  ];

  /// Base unit = meter
  static const Map<String, double> _unitToMeter = {
    'Kilometer': 1000.0,
    'Meter': 1.0,
    'Centimeter': 0.01,
    'Millimeter': 0.001,
  };

  @override
  void dispose() {
    _valueController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _convert() {
    final input = double.tryParse(_valueController.text);

    if (input == null || _fromUnit == null || _toUnit == null) {
      _clearResult();
      return;
    }

    final fromFactor = _unitToMeter[_fromUnit]!;
    final toFactor = _unitToMeter[_toUnit]!;

    final convertedValue = (input * fromFactor) / toFactor;

    setState(() {
      _result = convertedValue;
      _resultController.text =
          convertedValue.toStringAsFixed(6).replaceAll(RegExp(r'\.?0*$'), '');
    });
  }

  void _clearResult() {
    setState(() {
      _result = null;
      _resultController.clear();
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: _units
          .map(
            (unit) => DropdownMenuItem(
              value: unit,
              child: Text(unit),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _valueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Enter value',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'From',
                    value: _fromUnit,
                    onChanged: (value) {
                      setState(() => _fromUnit = value);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildDropdown(
                    label: 'To',
                    value: _toUnit,
                    onChanged: (value) {
                      setState(() => _toUnit = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Convert', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _resultController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Result',
                border: OutlineInputBorder(),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 20),
              Text(
                '${_valueController.text} $_fromUnit = '
                '${_resultController.text} $_toUnit',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
