library single_person_component;

import 'package:angular/angular.dart';
import 'package:rollcall/models/rollcall_db_project.dart';
import 'package:dabl_query/query.dart';
import 'dart:html';

@Component(
	selector: '[single-person]',
	templateUrl: 'packages/rollcall/components/single_person_component/single_person_component.html',
    publishAs: 'ctrl',
    useShadowDom: false)
class SinglePersonComponent {
	Person person;
	List<Attendance> attendances;
	bool saving = false;
	String name;

	SinglePersonComponent(RouteProvider routeProvider) {
		basePerson.retrieveByPK(int.parse(routeProvider.parameters['personId'])).then((Person p) {
			person = p;
			name = person.getName();
			refreshAttendances();
		});
	}

	void refreshAttendances() {
		if(person == null) {
			return;
		}
		person.getAttendancesRelatedByPersonId().then((res) => attendances = res);
	}

	void deleteAttendance(var attendedOn) {
		if(person == null || !window.confirm('Are you sure?')) {
			return;
		}
		Query q = new Query();
		q.add(baseAttendance.ATTENDED_ON, attendedOn);

		person.deleteAttendancesRelatedByPersonId(q).then((_) => refreshAttendances());
	}

	void update() {
		if(saving) {
			return;
		}
		saving = true;
		person.setName(name);
		person.save().then((_) {
			refreshAttendances();
			saving = false;
		});
	}
}