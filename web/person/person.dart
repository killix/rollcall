library Person;

import 'dart:web_sql';
import 'dart:async';

@MirrorsUsed(
		targets:'Person,DateTime',
		override: '*'
	)
import 'dart:mirrors';


class Person {
	String name;
	int dbKey;

	Person(this.name);

	Person.fromRaw(Map value):
		dbKey = value['id'],
		name = value['name'] {
	}

	String toString() {
		return "${this.name} - ${this.dbKey}";
	}

	// Serialize this to an object (a Map) to insert into the database.
	Map toRaw() {
		return {
			'id': dbKey,
			'name': name
		};
	}
}

class PersonStore {
	final List<Person> people = new List<Person>();
	SqlDatabase _db;

	PersonStore(this._db) {
		this._loadFromDB();
	}

	Future _loadFromDB() {
		Completer c = new Completer();
		_db.transaction((tx) {
			tx.executeSql("select * from person", [], (tx, results){
				for(var row in results.rows){
					people.add(new Person.fromRaw(row));
				}
				c.complete();
			});
		});
		return c.future;
	}

	Future<Person> add(String name) {
		Person p = new Person(name);
		Completer c = new Completer();

		_db.transaction((tx) {
			tx.executeSql("INSERT INTO person (name, created) VALUES (?, ?)", [p.name, new DateTime.now().toIso8601String()]);
			tx.executeSql('Select last_insert_rowid() as id', [], (tx, results) {
				for(var row in results.rows) {
					p.dbKey = row['id'];
					break;
				}
				people.add(p);
				c.complete(p);
			});
		});
		return c.future;
	}
}