library rollcall_routing;

import 'package:angular/angular.dart';
import 'package:angular/routing/module.dart';

void rollCallRouteInitializer(Router router, RouteViewFactory views) {
	views.configure({

		'people': ngRoute(
			path: '/people',
			view: 'views/people/index.html'),
		'totals': ngRoute(
			path: '/totals',
			view: 'views/totals/index.html'),
		'index': ngRoute(
			defaultRoute: true,
			path: '/',
			view: 'views/index.html')
	});
}