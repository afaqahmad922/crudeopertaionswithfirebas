import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crude_ops_flutter/database.dart';
import 'package:crude_ops_flutter/persondetails.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // Controllers for input fields
  TextEditingController namecontroller = TextEditingController();
  TextEditingController idcontroller = TextEditingController();
  TextEditingController cniccontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController universitycontroller = TextEditingController();
  TextEditingController cgpacontroller = TextEditingController();

  Stream<QuerySnapshot>? employeeStream;

  final int itemCount = 10;

  @override
  void initState() {
    super.initState();
    // Fetch the employee data from Firestore when the screen loads
    getEmployeeData();
  }

  // Fetch employee details from Firestore using snapshots (real-time updates)
  getEmployeeData() {
    employeeStream = FirebaseFirestore.instance.collection('Employee').snapshots();
    setState(() {});
  }

  // Function to show employee details in a list
  Widget allEmployeeDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: employeeStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // If data is available, show the list of employees
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(40.0),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${index + 1}', // Display index (1, 2, 3...)
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ), SizedBox(width: 10.0),
                            Text(
                              ": " + ds['Name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Populate the form with the current details
                                namecontroller.text = ds["Name"];
                                cniccontroller.text = ds["CNIC"];
                                dobcontroller.text = ds["Date of birth"];
                                agecontroller.text = ds["Age"];
                                universitycontroller.text = ds["University"];
                                cgpacontroller.text = ds["Cgpa"];
                                idcontroller.text = ds.id; // Get Firestore document ID
                                // Open the edit dialog
                                EditEmployeeDetails(ds.id);
                              },
                              child: Icon(Icons.edit),
                            ), SizedBox(width: 5.0,),
                            GestureDetector(
                              onTap: () async {

                                  await Databasemethods().deleteEmployeeDetails(ds);  // Pass the entire snapshot
                              },
                              child: Icon(Icons.delete_forever_outlined),
                            )
                          ],
                        ),
                        Text(
                          "CNIC: " + ds['CNIC'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Date of Birth: " + ds['Date of birth'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Age: " + ds['Age'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "University: " + ds['University'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Cgpa: " + ds['Cgpa'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("No employees found."));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => persondetails()),
          );
        },backgroundColor: Colors.blueGrey,
        elevation: 10,
        child: Icon(Icons.add, size: 30,),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5.0),
            Text(
              'Firebase',
              style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }

  // Edit employee details function
  Future EditEmployeeDetails(String id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Edit',
                    style: TextStyle(color: Colors.teal, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Details',
                    style: TextStyle(color: Colors.teal, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text('Profile Name', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: namecontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 5.0),
              Text('CNIC', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: cniccontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 5.0),
              Text('Date of Birth', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: dobcontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 5.0),
              Text('Age', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: agecontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 5.0),
              Text('University', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: universitycontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 5.0),
              Text('Cgpa', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5.0),
              TextField(
                controller: cgpacontroller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  onPressed: () async {
                    Map<String, dynamic> updateInfo = {
                      'Name': namecontroller.text,
                      'CNIC': cniccontroller.text,
                      'Date of birth': dobcontroller.text,
                      'Age': agecontroller.text,
                      'University': universitycontroller.text,
                      'Cgpa': cgpacontroller.text,
                    };

                    // Call the update method
                    await Databasemethods().updateEmployeeDetails(id, updateInfo);
                    Navigator.pop(context);
                  },
                  child: Text("Update",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
