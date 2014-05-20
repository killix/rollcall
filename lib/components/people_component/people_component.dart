library people_component;

import 'package:angular/angular.dart';

import 'package:rollcall/models/rollcall_db_project.dart';
import 'package:dabl/dbmanager.dart' as DBManager;
import 'package:dabl_query/query.dart';
import 'package:ddo/drivers/ddo_websql.dart';
import 'package:intl/intl.dart';
import 'dart:html';

@Component(
		selector: '[people]',
		templateUrl: 'packages/rollcall/components/people_component/people_component.html',
		cssUrl: 'packages/rollcall/components/people_component/people_component.css',
		applyAuthorStyles: true,
		publishAs: 'ctrl'
	)
class PeopleComponent {
	String name = '';

	List<Person> allPeople = new List<Person>();

	PeopleComponent() {
		loadPeople();
	}

	void loadPeople() {
		Query q = new Query();
		q.orderBy('name');
		basePerson.doSelect(q).then((List<Person> r) => allPeople = r);
	}

	void delete(Person person, MouseEvent event) {
		event.preventDefault();
		person.delete().then((_) {
			loadPeople();
		});
	}

	void addPerson() {
		Person p = new Person();
		p.setName(name);
		p.save().then((_) {
			loadPeople();
			name = '';
		});

	}

}
