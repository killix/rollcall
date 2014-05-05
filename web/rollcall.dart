import 'package:angular/angular.dart';
import '../rollcall_db_project.dart';
import 'package:dabl/dbmanager.dart' as DBManager;
import 'package:ddo/drivers/ddo_websql.dart';
import 'dart:async';

@MirrorsUsed(
	targets: 'DateTime,MonthTotal',
	override: '*'
)
import 'dart:mirrors';
import 'package:intl/intl.dart';
import 'package:dabl/dabl.dart';
import 'package:dabl_query/query.dart';

@NgController(
	selector: '[people]',
	publishAs: 'ctrl')
class PeopleController {
	String name = '';
	DateTime currentDate;
	bool showTotals = false;
	DABLDDO conn;
	List<MonthTotal> monthTotals = new List<MonthTotal>();
	List<Person> people = new List<Person>();
	List<int> peoplePresent = new List<int>();

	PeopleController() {
		DBManager.addConnection('rollcallDb', {'dbname': 'rollcallDb', 'driver': 'websql'});
		DBManager.setDriver(new DDOWebSQL(name: 'rollcallDb', version: '1.0'));
		conn = DBManager.getConnection();
		conn.exec('CREATE TABLE IF NOT EXISTS person ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name" TEXT NOT NULL,"created" TEXT NOT NULL)');
		conn.exec('CREATE TABLE IF NOT EXISTS attendance ("personId" INTEGER NOT NULL,"attendedOn" INTEGER NOT NULL,PRIMARY KEY ("personId", "attendedOn"))');
		DateTime now = new DateTime.now();
        currentDate = new DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
        loadPeople();
        updatePresent();
        baseAttendance.doSelect().then((List<Attendance> attendances){
        	for(Attendance a in attendances) {
        		print(a);
        	}
        });
	}

	void loadPeople() {
		Query q = new Query();
		q.order(basePerson.NAME);
		basePerson.doSelect(q).then((List<Person> p) {
			people = p;
		});
	}

	void addPerson() {
		Person p = new Person();
		p.setName(name);
		p.save().then((_) {
			loadPeople();
		});
		name = '';
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
		DateFormat formatter = new DateFormat(conn.getTimestampFormatter());
		q.add(baseAttendance.ATTENDED_ON, formatter.format(currentDate));

		baseAttendance.doSelect(q).then((List<Attendance> attendances){
			peoplePresent.clear();
			for(Attendance atn in attendances) {
				peoplePresent.add(atn.getPersonId());
			}
		});
	}

	List<MonthTotal> getMonthTotals() {
		if(monthTotals.isEmpty) {
			MonthTotal mt = new MonthTotal();
			DateTime now = new DateTime.now();
            DateTime lastMonth = new DateTime(now.year, now.month - 1);
            DateTime thisMonth = new DateTime(now.year, now.month);

			mt.month = new DateFormat.MMMM().format(lastMonth);
			mt.total = 0;
			List<int> done = new List<int>();
			Query q = new Query();
			q.add(baseAttendance.ATTENDED_ON, lastMonth.toIso8601String(), Query.GREATER_EQUAL);
			q.add(baseAttendance.ATTENDED_ON, thisMonth.toIso8601String(), Query.LESS_THAN);
			baseAttendance.doSelect(q).then((List<Attendance> attendances) {
				for(Attendance a in attendances) {
					if(done.contains(a.getPersonId())) {
						continue;
					}
					++mt.total;
					done.add(a.getPersonId());

				}
				monthTotals.add(mt);
			});
		}
		return monthTotals;
	}
}

@MirrorsUsed(
	targets:'MonthTotal',
	override: '*'
)
class MonthTotal {
	String month;
	int total;
	int ysa;
}

class RollcallModule extends Module {
	RollcallModule() {
		type(PeopleController);
	}
}

void main() {
	ngBootstrap(module: new RollcallModule());
}

