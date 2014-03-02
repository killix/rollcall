library RollCall;

import 'package:angular/angular.dart';
import 'person.dart';

@NgComponent(
	selector: 'person',
	publishAs: 'prson',
	templateUrl: 'person/personComponent.html',
	cssUrl: 'person/personComponent.css')
class PersonComponent {
	@NgAttr('person')
	Person person;
}