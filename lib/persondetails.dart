import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crude_ops_flutter/database.dart';
import 'package:intl/intl.dart';

class persondetails extends StatefulWidget {
  const persondetails({super.key});

  @override
  _persondetailsState createState() => _persondetailsState();
}

class _persondetailsState extends State<persondetails> {
  // Controllers for input fields
  TextEditingController namecontroller = TextEditingController();
  TextEditingController cniccontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController universitycontroller = TextEditingController();
  TextEditingController cgpacontroller = TextEditingController();

  // Add employee details to Firestore
  addEmployeeDetails() async {
    Map<String, dynamic> employeeData = {
      'Name': namecontroller.text,
      'CNIC': cniccontroller.text,
      'Date of birth': dobcontroller.text,
      'Age': agecontroller.text,
      'University': universitycontroller.text,
      'Cgpa': cgpacontroller.text,
    };
    await Databasemethods().addEmployeeDetails(employeeData);
    Navigator.pop(context); // Close the screen after adding
  }

  // Function to calculate age
  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--; // Subtract 1 year if the birthday hasn't occurred yet this year
    }
    return age;
  }

  // Function to show date picker and set DOB and calculate age
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Set the selected date in DOB field
      dobcontroller.text = DateFormat('yyyy-MM-dd').format(picked);

      // Calculate and set the age
      agecontroller.text = calculateAge(picked).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Add New Employee"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,)),
              SizedBox(height: 5.0,),
              Container(
                padding: EdgeInsets.only(left:  10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 5.0,),
              Text('CNIC', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,)),
              SizedBox(height: 5.0,),
              Container(
                padding: EdgeInsets.only(left:  10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                TextField(
                  controller: cniccontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 5.0,),
              // Date of Birth Text Field
              Text('Date of Birth', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _selectDate, // Open date picker when clicked
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: dobcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select Date of Birth',
                    ),
                    enabled: false, // Disable the text field so the user can't edit it manually
                  ),
                ),
              ),
              SizedBox(height: 5.0,),
              // Age Text Field
              // Age Text Field
              Text('Age', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: agecontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                  readOnly: true, // This field should be non-editable as it's calculated
                ),
              ),
              SizedBox(height: 5.0,),
              Text('University', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,)),
              SizedBox(height: 5.0,),
              Container(
                padding: EdgeInsets.only(left:  10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                TextField(
                  controller: universitycontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 5.0,),
              Text('Cgpa', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black,)),
              SizedBox(height: 5.0,),
              Container(
                padding: EdgeInsets.only(left:  10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                TextField(
                  controller: cgpacontroller,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 5.0,),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: addEmployeeDetails, style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
                  child: Text("Add Employee", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
