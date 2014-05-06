part of rollcallDb_project;

class Person extends basePerson {

	static String getPrimaryKey() => basePerson.getPrimaryKey();

	static Person retrieveFromPool(Object pkValue) => basePerson.retrieveFromPool(pkValue);

	static void insertIntoPool(Person obj) => basePerson.insertIntoPool(obj);

	static bool hasColumn(String columnName) => basePerson.hasColumn(columnName);

	static List<String> getColumns() => basePerson.getColumns();

	static List<String> getColumnNames() => basePerson.getColumnNames();

	static String getTableName() => basePerson.getTableName();

	static List<String> getPrimaryKeys() => basePerson.getPrimaryKeys();

	static bool isAutoIncrement() => basePerson.isAutoIncrement();

	static DABLDDO getConnection() => basePerson.getConnection();
}
