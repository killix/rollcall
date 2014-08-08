import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:bootjack/bootjack.dart';

import 'package:rollcall/routing/rollcall_router.dart';
import 'package:rollcall/components/rollcall_component/person_list_component.dart';
import 'package:rollcall/components/totals_component/month_total_component.dart';
import 'package:rollcall/components/people_component/people_component.dart';
import 'package:rollcall/components/single_person_component/single_person_component.dart';

class RollcallModule extends Module {
	RollcallModule() {
		Binding.printInjectWarning = false;
		bind(MonthTotalComponent);
		bind(PersonListController);
		bind(PeopleComponent);
		bind(SinglePersonComponent);
		bind(RouteInitializerFn, toValue: rollCallRouteInitializer);
		bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
	}
}

void main() {
	Tab.use();
	applicationFactory().addModule(new RollcallModule()).run();
}

