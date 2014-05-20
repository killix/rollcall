library person_list_component;

import 'package:angular/angular.dart';
import 'package:dabl/dabl.dart';

import 'package:rollcall/models/rollcall_db_project.dart';
import 'package:dabl/dbmanager.dart' as DBManager;
import 'package:dabl_query/query.dart';
import 'package:ddo/drivers/ddo_websql.dart';
import 'package:intl/intl.dart';
import 'dart:web_sql';

@Component(
	selector: '[person-list]',
	templateUrl: 'packages/rollcall/components/rollcall_component/person_list_component.html',
    //cssUrl: 'packages/Rollcall/components/rollcall_component/person_list_component.css',
	applyAuthorStyles: true,
	publishAs: 'ctrl')
class PersonListController {
	DateTime currentDate;
	DABLDDO conn;

	List<Person> people = new List<Person>();
	List<int> peoplePresent = new List<int>();


	PersonListController() {
		DBManager.addConnection('rollcallDb', {'dbname': 'rollcallDb', 'driver': 'websql'});

		DBManager.setDriver(new DDOWebSQL(name: 'rollcallDb', version: '1.0'));
		conn = DBManager.getConnection();
		conn.exec('CREATE TABLE IF NOT EXISTS person ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name" TEXT NOT NULL,"created" TEXT NOT NULL)');
		conn.exec('CREATE TABLE IF NOT EXISTS attendance ("personId" INTEGER NOT NULL,"attendedOn" INTEGER NOT NULL,PRIMARY KEY ("personId", "attendedOn"))');
		Query q = new Query();
		q.add(baseAttendance.ATTENDED_ON, '%:%', Query.CONTAINS);
		baseAttendance.doDelete(q);
		DateTime now = new DateTime.now();
        currentDate = new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
        loadPeople();
        updatePresent();
	}

	void loadPeople() {
		Query q = new Query();
		q.order(basePerson.NAME);
		basePerson.doSelect(q).then((List<Person> p) {
			people = p;
		});
	}

	void togglePresent(var dbKey) {
		Query q = new Query();
		q.add(baseAttendance.PERSON_ID, dbKey);
		DateFormat formatter = new DateFormat(conn.getTimestampFormatter());
		q.add(baseAttendance.ATTENDED_ON, formatter.format(currentDate));
		baseAttendance.doSelectOne(q).then((Attendance a) {
			if(a != null) {
				a.delete().then((_) {
					loadPeople();
					updatePresent();
        		});
			} else {
				a = new Attendance();
				a.setPersonId(dbKey);
				a.setAttendedOn(currentDate.toIso8601String());
				a.save().then((_) {
					loadPeople();
					updatePresent();
        		});
			}
		});
	}

	bool isPresent(var dbKey) {
		return peoplePresent.contains(dbKey);
	}

	void updatePresent() {
		Query q = new Query();
		q.add(baseAttendance.ATTENDED_ON, currentDate.millisecondsSinceEpoch);

		baseAttendance.doSelect(q).then((List<Attendance> attendances){
			peoplePresent.clear();
			for(Attendance atn in attendances) {
				peoplePresent.add(atn.getPersonId());
			}
		});
	}
}