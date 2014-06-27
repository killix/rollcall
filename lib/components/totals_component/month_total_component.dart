library month_total_component;

import 'package:angular/angular.dart';
import 'package:rollcall/models/month_total.dart';
import 'package:intl/intl.dart';
import 'package:rollcall/models/rollcall_db_project.dart';
import 'package:dabl_query/query.dart';

@Component(
	selector: '[month-total]',
	templateUrl: 'packages/rollcall/components/totals_component/month_total_component.html',
    publishAs: 'ctrl',
    useShadowDom: false)
class MonthTotalComponent {
	List<MonthTotal> monthTotals = new List<MonthTotal>();
	bool _generatingMonthTotals = false;
	bool showTotals = false;

	List<MonthTotal> getMonthTotals() {
		if(monthTotals.isEmpty && !_generatingMonthTotals) {
			_generatingMonthTotals = true;
			MonthTotal mt = new MonthTotal();
			DateTime now = new DateTime.now();
            DateTime lastMonth = new DateTime(now.year, now.month - 1);
            DateTime thisMonth = new DateTime(now.year, now.month);

			mt.month = new DateFormat.MMMM().format(lastMonth);
			mt.total = 0;
			List<int> done = new List<int>();
			Query q = new Query();
			q.add(baseAttendance.ATTENDED_ON, lastMonth.millisecondsSinceEpoch, Query.GREATER_EQUAL);
			q.add(baseAttendance.ATTENDED_ON, thisMonth.millisecondsSinceEpoch, Query.LESS_THAN);
			q.groupBy('personId');
			baseAttendance.doCount(q).then((int cnt) {
				mt.total = cnt;
				monthTotals.add(mt);
				_generatingMonthTotals = false;
			});
		}
		return monthTotals;
	}
}