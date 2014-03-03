library Person;

import 'dart:indexed_db';
import 'dart:async';
import 'dart:html';

class Person {
	String name;
	var dbKey;

	Person(this.name);

	Person.fromRaw(key, Map value):
		dbKey = key,
		name = value['name'] {
	}

      // Serialize this to an object (a Map) to insert into the database.
	Map toRaw() {
    	return {
      		'name': name
    	};
	}
}

class PersonStore {
	static const String PERSON_STORE = 'personStore';
	static const String NAME_INDEX = 'name_index';
	String _dbName;
	final List<Person> people = new List<Person>();
	Database _db;

	PersonStore(this._dbName);

	Future open(){
		return window.indexedDB.open(_dbName,
		version: 1,
		onUpgradeNeeded: _initializeDatabase)
	.then(_loadFromDB);
	}

	void _initializeDatabase(VersionChangeEvent e) {
		Database db = (e.target as Request).result;

		var objectStore = db.createObjectStore(PERSON_STORE,
		    autoIncrement: true);

		// Create an index to search by name,
		// unique is true: the index doesn't allow duplicate milestone names.
		objectStore.createIndex(NAME_INDEX, 'name', unique: true);
	}

	Future _loadFromDB(Database db) {
		_db = db;

		var trans = db.transaction(PERSON_STORE, 'readonly');
		var store = trans.objectStore(PERSON_STORE);

		var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
		cursors.listen((cursor) {
			Person person = new Person.fromRaw(cursor.key, cursor.value);
			people.add(person);
		});
		return cursors.length.then((_) {
  			return people.length;
		});
	}

	Future<Person> add(String name) {
        Person p = new Person(name);
        Map personAsMap = p.toRaw();

        var transaction = _db.transaction(PERSON_STORE, 'readwrite');
        var objectStore = transaction.objectStore(PERSON_STORE);

        objectStore.add(personAsMap).then((addedKey) {
          p.dbKey = addedKey;
        });

        return transaction.completed.then((_) {
        	people.add(p);
        	return p;
        });
	}
}