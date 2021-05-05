import 'package:firebase_database/firebase_database.dart';

class Hestory {
  String paymentMethod;
  String createdAt;
  String status;
  String farse;
  String dropOff;
  String pickUp;

  Hestory(
      {this.createdAt,
      this.dropOff,
      this.farse,
      this.paymentMethod,
      this.pickUp,
      this.status});

  Hestory.fromSnapshot(DataSnapshot dataSnapshot) {
    paymentMethod = dataSnapshot.value["payment_method"];
    createdAt = dataSnapshot.value["created_at"];
    status = dataSnapshot.value["status"];
    farse = dataSnapshot.value["fares"];
    dropOff = dataSnapshot.value["droppOff_address"];
    pickUp = dataSnapshot.value["pickup_address"];
  }
}
