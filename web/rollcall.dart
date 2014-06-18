import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:bootjack/bootjack.dart';
import 'package:logging/logging.dart';

import 'package:rollcall/routing/rollcall_router.dart';
import 'package:rollcall/components/rollcall_component/person_list_component.dart';
import 'package:rollcall/components/totals_component/month_total_component.dart';
import 'package:rollcall/components/people_component/people_component.dart';

class RollcallModule extends Module {
	RollcallModule() {
		bind(MonthTotalComponent);
		bind(PersonListController);
		bind(PeopleComponent);
		value(RouteInitializerFn, rollCallRouteInitializer);
		factory(NgRoutingUsePushState,
        	(_) => new NgRoutingUsePushState.value(false));
	}
}

void main() {
	Tab.use();
	applicationFactory().addModule(new RollcallModule()).run();
}

