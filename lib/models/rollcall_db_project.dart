library rollcallDb_project;

import 'package:dabl/dabl.dart';
import 'package:dabl/dbmanager.dart' as DBManager;
export 'package:dabl/dbmanager.dart';
import 'package:dabl_query/query.dart';
import 'package:intl/intl.dart';
import 'dart:async';

@MirrorsUsed(
	targets: 'Person,Attendance,basePerson,baseAttendance,ApplicationModel',
	override: '*'
)
import 'dart:mirrors';

part 'application_model.dart';

part 'attendance.dart';
part 'base/base_attendance.dart';
part 'base/base_person.dart';
part 'person.dart';
