import 'package:cloud_firestore/cloud_firestore.dart';

class Databasemethods {
  // Get employee details
  Future<QuerySnapshot> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection('Employee').get();
  }

  // Add new employee
  Future<void> addEmployeeDetails(Map<String, dynamic> employeeData) async {
    await FirebaseFirestore.instance.collection('Employee').add(employeeData);
  }

  // Update employee details
  Future<void> updateEmployeeDetails(String employeeId, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance.collection('Employee').doc(employeeId).update(updateInfo);
  }

  Future<void> deleteEmployeeDetails(DocumentSnapshot employeeDoc) async {
    String employeeId = employeeDoc.id;
      await FirebaseFirestore.instance.collection('Employee').doc(employeeId).delete();
    }
  }

