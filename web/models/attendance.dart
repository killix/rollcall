part of rollcallDb_project;

class Attendance extends baseAttendance {

	static String getPrimaryKey() => baseAttendance.getPrimaryKey();

	static Attendance retrieveFromPool(Object pkValue) => baseAttendance.retrieveFromPool(pkValue);

	static void insertIntoPool(Attendance obj) => baseAttendance.insertIntoPool(obj);

	static bool hasColumn(String columnName) => baseAttendance.hasColumn(columnName);

	static List<String> getColumns() => baseAttendance.getColumns();

	static List<String> getColumnNames() => baseAttendance.getColumnNames();

	static String getTableName() => baseAttendance.getTableName();

	static List<String> getPrimaryKeys() => baseAttendance.getPrimaryKeys();

	static bool isAutoIncrement() => baseAttendance.isAutoIncrement();

	static DABLDDO getConnection() => baseAttendance.getConnection();
}
