import 'package:flutter/material.dart';

import 'Controller/sqlite_db.dart';

class BMICalc extends StatefulWidget {
  const BMICalc({Key? key}) : super(key: key);

  @override
  State<BMICalc> createState() => _BMICalcState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController heightController = TextEditingController();
final TextEditingController weightController = TextEditingController();
final TextEditingController bmiController = TextEditingController();
double bmiResult = 0.0;
String status = '';
String selectedGender = 'male';

class _BMICalcState extends State<BMICalc> {
  //double? bmiResult;


  void calculateBMI() {
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    String gender = selectedGender?.toString() ?? "";
    //String status = '';

    setState(() {
      if (selectedGender == 'male') {
        bmiResult = weight / (height * height / 1000) * 10;
        if (bmiResult < 18.5) {
          status = 'Underweight. Careful during strong wind!';
        } else if (bmiResult >= 18.6 && bmiResult <= 24.9) {
          status = 'That ideal! Please maintain';
        } else if (bmiResult >= 25 && bmiResult <= 29.9) {
          status = 'Overweight! Work out please';
        } else {
          status = 'Whoa Obese! Dangerous mate!';
        }
      }
      else if (selectedGender == 'female'){
        bmiResult = weight / (height * height / 1000) * 10;
        if (bmiResult < 16) {
          status = 'Underweight. Careful during strong wind!';
        } else

        if (bmiResult >= 17 && bmiResult <= 22) {
          status = 'That ideal! Please maintain';
        } else

        if (bmiResult >= 23 && bmiResult <= 27) {
          status = 'Overweight! Work out please';
        } else {
          status = 'Whoa Obese! Dangerous mate!';
        }
      }
      Map<String, dynamic> InsertData = {
        'username': nameController.text,
        'weight': double.parse(weightController.text),
        'height': double.parse(heightController.text),
        'gender': selectedGender,
        'bmi_status': status,
      };
      SQLiteDB().insert('bmi', InsertData);

      nameController.clear();
      heightController.clear();
      weightController.clear();
      bmiController.clear();


    });
  }
  @override
  void initState() {
    super.initState();
    LastData(); // Call the function to fetch data when the widget is initialized
  }

  Future<void> LastData() async {
    try {
      List<Map<String, dynamic>> result = await SQLiteDB().queryAll('bmi');
      if (result.isNotEmpty) {
        // Assuming the last inserted record is the first one in the result list
        Map<String, dynamic> lastData = result.last;

        setState(() {
          nameController.text = lastData['username'] ?? '';
          heightController.text = lastData['height'].toString() ?? '';
          weightController.text = lastData['weight'].toString() ?? '';
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Your Fullname'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height in cm; 170'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight in KG'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: bmiController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'BMI Value - ${bmiResult?.toStringAsFixed(2)}',
                ),
              ),
            ),
            // Radio buttons for gender
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Text('Male'),
                SizedBox(width: 20.0),
                Radio<String>(
                  value: 'female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: calculateBMI,
              child: Text('Calculate BMI and Save'),
            ),
            SizedBox(height: 20.0),
            Text(
              ' ${selectedGender} $status',
            ),
//hello this is imran


          ],
        ),
      ),
    );
  }
}
