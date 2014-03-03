import 'package:angular/angular.dart';
import 'person/person.dart';
import 'attendance/attendance.dart';

@MirrorsUsed(override:'*')
import 'dart:mirrors';


@NgController(
	selector: '[people]',
	publishAs: 'ctrl')
class PeopleController {
	String name = '';
	PersonStore db = new PersonStore('rollCallDB');
	AttendanceStore aDb = new AttendanceStore('rollCallDB');

	PeopleController() {
		db.open();
		aDb.open();
	}

	List<Person> getPeople() {
		return db.people;
	}

	void addPerson() {
		db.add(name);
		name = '';
	}

	void markPresent(var dbKey) {
		aDb.add(dbKey);
	}

	bool isPresent(var dbKey) {
		DateTime now = new DateTime.now();
		now = new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
		if(aDb.attendances.where((a) {
			 return (a.dbKey == dbKey && a.attendedOn == now);
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

