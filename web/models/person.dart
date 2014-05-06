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

	static bool isAutoIncrement() => basePerson.isAutoIncrement;

	static DABLDDO getConnection() => basePerson.getConnection();

  @override
  int archive() {
    // TODO: implement archive
  }

  @override
  Model copy() {
    // TODO: implement copy
  }

  @override
  Model fromArray(Map<String, Object> array) {
    // TODO: implement fromArray
  }

  @override
  bool fromAssociativeResultArray(Map<String, Object> values) {
    // TODO: implement fromAssociativeResultArray
  }

  @override
  bool fromNumericResultArray(List values, int startCol) {
    // TODO: implement fromNumericResultArray
  }

  @override
  String getLibraryName() {
    // TODO: implement getLibraryName
  }

  @override
  bool hasPrimaryKeyValues() {
    // TODO: implement hasPrimaryKeyValues
  }

  @override
  Map<String, Object> jsonSerialize() {
    // TODO: implement jsonSerialize
  }

  @override
  Model setCacheResults([bool value = true]) {
    // TODO: implement setCacheResults
  }

  @override
  Model setDirty(bool dirty) {
    // TODO: implement setDirty
  }

  @override
  Map<String, Object> toArray() {
    // TODO: implement toArray
  }
}
