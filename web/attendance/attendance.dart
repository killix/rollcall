library Attendance;

import 'dart:indexed_db';
import 'dart:async';
import 'dart:html';

class Attendance {
	var personId;
	DateTime attendedOn;
	var dbKey;

	Attendance(this.personId, DateTime aton) {
		attendedOn = new DateTime(aton.year, aton.month, aton.day, 0, 0, 0, 0);
	}

	Attendance.fromRaw(key, Map value):
		dbKey = key,
		personId = value['personId'] {
		attendedOn = new DateTime.fromMillisecondsSinceEpoch(value['attendedOn']);
		attendedOn = new DateTime(attendedOn.year, attendedOn.month, attendedOn.day, 0, 0, 0, 0);
	}

      // Serialize this to an object (a Map) to insert into the database.
	Map toRaw() {
    	return {
      		'personId': personId,
      		'attendedOn': attendedOn.millisecondsSinceEpoch
    	};
	}
}

class AttendanceStore {
	static const String ATTENDANCE_STORE = 'attendanceStore';
	static const String PERSON_INDEX = 'person_index';
	String _dbName;
	final List<Attendance> attendances = new List<Attendance>();
	Database _db;

	AttendanceStore(this._dbName);

    	Future open(){
    		return window.indexedDB.open(_dbName,
    		version: 2,
    		onUpgradeNeeded: _initializeDatabase)
    	.then(_loadFromDB);
    	}

    	void _initializeDatabase(VersionChangeEvent e) {
    		Database db = (e.target as Request).result;

    		var objectStore = db.createObjectStore(ATTENDANCE_STORE);

    		objectStore.createIndex(PERSON_INDEX, 'personId');
    	}

    	Future _loadFromDB(Database db) {
    		_db = db;

    		var trans = db.transaction(ATTENDANCE_STORE, 'readonly');
    		var store = trans.objectStore(ATTENDANCE_STORE);

    		var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    		cursors.listen((cursor) {
    			Attendance attend = new Attendance.fromRaw(cursor.key, cursor.value);
    			attendances.add(attend);
    		});
    		return cursors.length.then((_) {
      			return attendances.length;
    		});
    	}

    	Future<Attendance> add(var pKey) {
			Attendance a = new Attendance(pKey, new DateTime.now());
            Map attendanceAsMap = a.toRaw();

            var transaction = _db.transaction(ATTENDANCE_STORE, 'readwrite');
            var objectStore = transaction.objectStore(ATTENDANCE_STORE);

            objectStore.add(attendanceAsMap).then((addedKey) {
              a.dbKey = addedKey;
            });

            return transaction.completed.then((_) {
            	attendances.add(a);
            	return a;
            });
    	}
}