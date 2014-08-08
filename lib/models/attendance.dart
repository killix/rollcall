part of rollcallDb_project;

@reflectedModel
class Attendance extends baseAttendance {

	static String getPrimaryKey() => baseAttendance.getPrimaryKey();

	static Attendance retrieveFromPool(Object pkValue) => baseAttendance.retrieveFromPool(pkValue);

	static void insertIntoPool(Attendance obj) => baseAttendance.insertIntoPool(obj);

	static bool hasColumn(String columnName) => baseAttendance.hasColumn(columnName);

	static List<String> getColumns() => baseAttendance.getColumns();

	static List<String> getColumnNames() => baseAttendance.getColumnNames();

	static String getTableName() => baseAttendance.getTableName();

	static List<String> getPrimaryKeys() => baseAttendance.getPrimaryKeys();

	static bool isAutoIncrement() => baseAttendance.isAutoIncrement;

	static DABLDDO getConnection() => baseAttendance.getConnection();

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
