library Attendance;

import 'dart:async';
import 'dart:web_sql';

class Attendance {
	var personId;
	DateTime attendedOn;

	Attendance(this.personId, DateTime aton) {
		attendedOn = new DateTime(aton.year, aton.month, aton.day, 0, 0, 0, 0);
	}

	Attendance.fromRaw(Map value):
		personId = value['personId'] {
		attendedOn = new DateTime.fromMillisecondsSinceEpoch(value['attendedOn']);
		attendedOn = new DateTime(attendedOn.year, attendedOn.month, attendedOn.day, 0, 0, 0, 0);
	}

	// Serialize this to an object (a Map) to insert into the database.
	List toRaw() {
		return [
			personId,
			attendedOn.millisecondsSinceEpoch
		];
	}

	String toString() {
		return "${this.personId} - ${this.attendedOn.toLocal()}";
	}
}

class AttendanceStore {
	final List<Attendance> attendances = new List<Attendance>();
	SqlDatabase _db;

	AttendanceStore(this._db) {
		_loadFromDB();
	}

	Future _loadFromDB() {
		Completer c = new Completer();
		_db.transaction((tx) {
			tx.executeSql("select * from attendance", [], (tx, results){
				for(var row in results.rows){
					attendances.add(new Attendance.fromRaw(row));
				}
				c.complete();
			});
		});
		return c.future;
	}

	Future<Attendance> add(var pKey) {
		Attendance a = new Attendance(pKey, new DateTime.now());
		Completer c = new Completer();

		_db.transaction((tx) {
			tx.executeSql("INSERT INTO attendance (personId, attendedOn) VALUES (?, ?)", a.toRaw(), (tx, results) {
				attendances.add(a);
				c.complete(a);
			});
		});
		return c.future;
	}

	Future remove(Attendance a) {
		Completer c = new Completer();
		_db.transaction((tx) {
			tx.executeSql("DELETE FROM attendance WHERE personId = ? and attendedOn = ?", [a.personId, a.attendedOn.millisecondsSinceEpoch], (tx, results){
				attendances.removeWhere((test) {
					return test.personId == a.personId && test.attendedOn == a.attendedOn;
				});
				c.complete();
			});
		});
		return c.future;
	}

	String toString() {
		return this.attendances.toString();
	}
}