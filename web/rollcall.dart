import 'package:angular/angular.dart';
import 'person/personComponent.dart';
import 'person/person.dart';

@MirrorsUsed(override:'*')
import 'dart:mirrors';

@NgController(
	selector: '[people]',
	publishAs: 'ctrl')
class PeopleController {
	String name = '';
	List<Person> people = new List<Person>();

	void addPerson() {
		Person p = new Person();
		p.name = name;
		name = '';
		people.add(p);
	}
}

class RollcallModule extends Module {
	RollcallModule() {
		type(PeopleController);
		type(PersonComponent);
	}
}

void main() {
	ngBootstrap(module: new RollcallModule());
}

