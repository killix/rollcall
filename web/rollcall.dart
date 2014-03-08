import 'package:angular/angular.dart';
import 'person/person.dart';
import 'attendance/attendance.dart';
import 'dart:html';
import 'dart:web_sql';

@NgController(
	selector: '[people]',
	publishAs: 'ctrl')
class PeopleController {
	String name = '';
	PersonStore pDB;
	AttendanceStore aDb;

	PeopleController() {
		SqlDatabase db = window.openDatabase('rollcallDb', '1.0', 'Rollcall DB', 2 * 1024 * 1024);
		db.transaction((tx) {
			tx.executeSql('CREATE TABLE IF NOT EXISTS person ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name" TEXT NOT NULL,"created" TEXT NOT NULL)', []);
			tx.executeSql('CREATE TABLE IF NOT EXISTS attendance ("personId" INTEGER NOT NULL,"attendedOn" INTEGER NOT NULL,PRIMARY KEY ("personId", "attendedOn"))', []);
		});
		pDB = new PersonStore(db);
		aDb = new AttendanceStore(db);
	}

	List<Person> getPeople() {
		return pDB.people;
	}

	void addPerson() {
		pDB.add(name);
		name = '';
	}

	void markPresent(var dbKey) {
		Person p = pDB.people.firstWhere((p) => p.dbKey == dbKey);
		aDb.add(dbKey);
	}

	bool isPresent(var dbKey) {

		DateTime now = new DateTime.now();
		now = new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
		if(aDb.attendances.where((a) {
			 return (a.personId == dbKey && a.attendedOn == now);
		}).length > 0) {
			return true;
		}
		return false;
	}
}

class RollcallModule extends Module {
	RollcallModule() {
		type(PeopleController);
	}
}

void main() {
	ngBootstrap(module: new RollcallModule());
}

