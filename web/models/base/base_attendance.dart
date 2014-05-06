part of rollcallDb_project;

abstract class baseAttendance extends ApplicationModel {

	static const String PERSON_ID = 'attendance.personId';
	static const String ATTENDED_ON = 'attendance.attendedOn';
	/**
	 * Name of the table
	 */
	static const String _tableName = 'attendance';

	/**
	 * Cache of objects retrieved from the database
	 */
	static Map<String, Attendance> _instancePool = new Map<String, Attendance>();

	static int _instancePoolCount = 0;

	static bool _poolEnabled = true;

	/**
	 * List of objects to batch insert
	 */
	static List<Attendance> _insertBatch = new List<Attendance>();

	static int _insertBatchSize = 500;

	/**
	 * List of all primary keys
	 */
	static final List<String> _primaryKeys = [
		'personId',
		'attendedOn',
	];

	/**
	 * string name of the primary key column
	 */
	static const String _primaryKey = '';

	/**
	 * true if primary key is an auto-increment column
	 */
	static const bool _isAutoIncrement = false;

	/**
	 * List of all fully-qualified(table.column) columns
	 */
	static final List<String> _columns = [
		baseAttendance.PERSON_ID,
		baseAttendance.ATTENDED_ON,
	];

	/**
	 * List of all column names
	 */
	static final List<String> _columnNames = [
		'personId',
		'attendedOn',
	];

	/**
	 * map of all column types
	 */
	static final Map<String, String> _columnTypes = {
		'personId': Model.COLUMN_TYPE_INTEGER,
		'attendedOn': Model.COLUMN_TYPE_TIMESTAMP,
	};

	/**
	 * `personId` INTEGER NOT NULL
	 */
	int _personId;

	/**
	 * `attendedOn` TIMESTAMP NOT NULL
	 */
	String _attendedOn;
			
	/** 
	 * Gets the value of the personId field
	 */
	int getPersonId() {
		return _personId;
	}

	/**
	 * Sets the value of the personId field
	 */

	Attendance setPersonId(Object value) {
		return setColumnValue('personId', value, Model.COLUMN_TYPE_INTEGER);
	}
			
	/** 
	 * Gets the value of the attendedOn field
	 */
	String getAttendedOn([String format = null]) {
		if(null == _attendedOn || null == format) {
			return _attendedOn;
		}
		if(0 == _attendedOn.indexOf('0000-00-00')) {
			return null;
		}
		DateFormat formatter = new DateFormat(format);
		return formatter.format(DateTime.parse(_attendedOn));
	}

	/**
	 * Sets the value of the attendedOn field
	 */

	Attendance setAttendedOn(Object value) {
		return setColumnValue('attendedOn', value, Model.COLUMN_TYPE_TIMESTAMP);
	}

	static DABLDDO getConnection() {
		return DBManager.getConnection('rollcallDb');
	}

	static Attendance create() => new Attendance();

	static Query getQuery([Map params = null, Query q = null]) {
		q = q != null ? q.clone() : new Query();
		if(q.getTable() == null) {
			q.setTable(baseAttendance.getTableName());
		}

		if(params == null) {
			params = new Map();
		}

		//filters
		for(Object k in params.keys) {
			if(baseAttendance.hasColumn(k)) {
				q.add(k, params[k]);
			}
		}

		//order_by
		if(params.containsKey('order_by') && baseAttendance.hasColumn(params['order_by'])) {
			q.orderBy(params['order_by'], params.containsKey('dir') ? Query.DESC : Query.ASC);
		}

		return q;
	}

	static String getTableName() => baseAttendance._tableName;

	static List<String> getColumnNames() => baseAttendance._columnNames;

	static List<String> getColumns() => baseAttendance._columns;

	static Map<String, String> getColumnTypes() => baseAttendance._columnTypes;

	static String getColumnType(String columnName) => baseAttendance._columnTypes[baseAttendance.normalizeColumnName(columnName)];

	static List<String> _columnsCache = new List<String>();

	static bool hasColumn(String columnName) {
		
		if (null == _columnsCache || _columnsCache.isEmpty) {
			_columnsCache = baseAttendance._columnNames.map((String s) => s.toLowerCase()).toList();
		}
		return _columnsCache.contains(baseAttendance.normalizeColumnName(columnName).toLowerCase());
	}

	static List<String> getPrimaryKeys() => baseAttendance._primaryKeys;

	static String getPrimaryKey() => baseAttendance._primaryKey;

	static bool isAutoIncrement() => baseAttendance._isAutoIncrement;

	static String normalizeColumnName(String columnName) => Model.normalizeColumnName(columnName);

	/**
	 * Searches the database for a row with the ID(primary key) that matches
	 * the one input.
	 */
	static Future<Attendance> retrieveByPK(Object the_pk) {
		throw new Exception('This table was more than one primary key. Use retrieveByPKs() instead');
	}

	/**
	 * Searches the database for a row with the primary keys that match
	 * the ones input
	 */
	static Future<Attendance> retrieveByPKs(int person_id, String attended_on) {
		if(null == person_id) {
			return null;
		}
		if(null == attended_on) {
			return null;
		}
		if(baseAttendance._poolEnabled) {
			Attendance poolInstance = baseAttendance.retrieveFromPool([person_id, attended_on].join('-'));
			if(null != poolInstance) {
				return new Future.value(poolInstance);
			}
		}
		Query q = new Query();
		q.add('personId', person_id);
		q.add('attendedOn', attended_on);

		return baseAttendance.doSelectOne(q);
	}

	/**
	 * Searches the database for a row with a personId
	 * that matches the one provided
	 */
	static Future<Attendance> retrieveByPersonId(int value) {
		return baseAttendance.retrieveByColumn('personId', value);
	}

	/**
	 * Searches the database for a row with a attendedOn
	 * that matches the one provided
	 */
	static Future<Attendance> retrieveByAttendedOn(String value) {
		return baseAttendance.retrieveByColumn('attendedOn', value);
	}

	static Future<Attendance> retrieveByColumn(String field, Object value) {
		Query q = new Query();
		q.add(field, value);
		q.setLimit(1);
		return baseAttendance.doSelectOne(q);
	}

	/**
	 * Populates and returns a List of Attendance objects with the results of a query
	 * If the query returns no results, returns an empty List
	 */
	static Future<List<Attendance>> fetch(String queryString) {
		DABLDDO conn = baseAttendance.getConnection();
		Completer c = new Completer();
		conn.query(queryString).then((DDOStatement result) {
			c.complete(baseAttendance.fromResult(result, [Attendance]));
		});
		return c.future;
	}

	/**
	 * Returns a List of Attendance objects from a DDOStatement (Query result)
	 */
	static List<Attendance> fromResult(DDOStatement result, [List<Type> classNames = null, bool usePool = null]) {
		if (null == usePool) {
			usePool = baseAttendance._poolEnabled;
		}

		if(classNames == null) {
			classNames = new List<Type>();
			classNames.add(reflect(new Symbol('Attendance')).type.reflectedType);
		}
		List<Attendance> results = new List<Attendance>();
		for(Model m in Model.fromResult(result, classNames, usePool)) {
			results.add(m as Attendance);
		}

		return results;
	}

	/**
	 * Casts values of int fields to (int)
	 */
	/* Unneccessary method?
	Attendance castInts() {
		personId = (null == personId) ? null : int.parse(_personId);
		return this;
	}
	*/

	/**
	 * Add (or replace) to the instance pool
	 */
	static void insertIntoPool(Attendance obj) {
		if(!baseAttendance._poolEnabled) {
			return;
		}
		if (baseAttendance._instancePoolCount > Model.MAX_INSTANCE_POOL_SIZE) {
			return;
		}

		baseAttendance._instancePool[obj.getPrimaryKeyValues().values.join('-')] = obj;
		baseAttendance._instancePoolCount = baseAttendance._instancePool.length;
	}

	/**
	 * Return the cached instance from the pool
	 */
	static Attendance retrieveFromPool(Object pkValue) {
		if(!baseAttendance._poolEnabled || null == pkValue) {
			return null;
		}
		String key = pkValue.toString();
		if(_instancePool.containsKey(key)) {
			return _instancePool[key];
		}
		return null;
	}

	/**
	 * Remove the object from the instance pool.
	 */
	static void removeFromPool(Object obj) {
		String pk = (obj is Model) ? obj.getPrimaryKeyValues().values.join('-') : obj.toString();
		if(baseAttendance._instancePool.containsKey(pk)) {
			baseAttendance._instancePool.remove(pk);
			baseAttendance._instancePoolCount = baseAttendance._instancePool.length;
		}
	}

	/**
	 * Empty the instance pool.
	 */
	static void flushPool() => baseAttendance._instancePool.clear();

	static void setPoolEnabled([bool b = true]) {
		baseAttendance._poolEnabled = b;
	}
	
	static bool getPoolEnabled() => baseAttendance._poolEnabled;
	
	static Future<int> doCount([Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = baseAttendance.getConnection();
		if (q.getTable() == null) {
			q.setTable(baseAttendance.getTableName());
		}
		return q.doCount(conn);
	}

	static Future<int> doDelete(Query q, [bool flushPool = true]) {
		DABLDDO conn = baseAttendance.getConnection();
		q = q.clone();
		if (q.getTable() == null) {
			q.setTable(baseAttendance.getTableName());
		}
		Future<int> result = q.doDelete(conn);
		
		if (flushPool) {
			baseAttendance.flushPool();
		}
		return result;
	}

	static Future<List<Attendance>> doSelect([Query q = null, List<Type> additionalClasses = null]) {
		if(additionalClasses == null) {
			additionalClasses = new List<Type>();
		}
		additionalClasses.insert(0, Attendance);
		Completer c = new Completer();
		baseAttendance.doSelectRS(q).then((DDOStatement result) {
			c.complete(baseAttendance.fromResult(result, additionalClasses));
		});
		return c.future;
	}

	static Future<Attendance> doSelectOne([Query q = null, List<Type> additionalClasses = null]) {
		q = q != null ? q.clone() : new Query();
		q.setLimit(1);
		Completer c = new Completer();
		baseAttendance.doSelect(q, additionalClasses).then((List<Attendance> objs) {
			c.complete(objs.isNotEmpty ? objs.first : null);
		});
		return c.future;
	}

	static Future<int> doUpdate(Map columnValues, [Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = baseAttendance.getConnection();

		if (q.getTable() == null) {
			q.setTable(baseAttendance.getTableName());
		}

		return q.doUpdate(columnValues, conn);
	}

	/**
	 * Set the maximum insert batch size, once this size is reached the batch automatically inserts.
	 */
	static int setInsertBatchSize([int size = 500]) => baseAttendance._insertBatchSize = size;
	
	/**
	 * Queue for batch insert
	 */
	Attendance queueForInsert() {
		if(baseAttendance._insertBatch.length >= baseAttendance._insertBatchSize) {
			baseAttendance.insertBatch();
		}

		baseAttendance._insertBatch.add(this);

		return this;
	}

	static Future<int> insertBatch() {
		if (baseAttendance._insertBatch.isEmpty) {
			return new Future.value(0);
		}

		DABLDDO conn = baseAttendance.getConnection();
		List<String> columns = baseAttendance.getColumnNames();
		String quotedTable = conn.quoteIdentifier(baseAttendance.getTableName());
	
		List values = new List();

		List<String> queryS = new List<String>();
		queryS.add('INSERT INTO ${quotedTable} (${columns.map((String s) => conn.quoteIdentifier(s)).join(', ')}) VALUES');

		List<String> placeHolders;
		StringFormat formatter = new DateFormat(conn.getTimestampFormatter());
		String now = formatter.format(new DateTime.now());
		for(Attendance obj in baseAttendance._insertBatch) {
			placeHolders = new List<String>();

			if (!obj.validate()) {
				throw new Exception('Cannot save Attendance with validation errors: ${obj.getValidationErrors().join(', ')}');
			}

			for (String column in columns) {
				values.add(obj.getColumn(column));
				placeHolders.add('?');
			}
			queryS.add('(${placeHolders.join(', ')})');
		}

		QueryStatement statement = new QueryStatement(conn);
		statement.setString(queryS.join('\n'));
		statement.setParams(values);
		Completer c = new Completer();
		statement.bindAndExecute().then((DDOStatement results) {
			for (Attendance obj in baseAttendance._insertBatch) {
				obj.setNew(false);
				obj.resetModified();
				if(obj.hasPrimaryKeyValues()) {
					baseAttendance.insertIntoPool(obj);
				} else {
					obj.setDirty(true);
				}
			}
			baseAttendance._insertBatch.clear();
			c.complete(results.rowCount());
		});
		return c.future;
	}

	static Object coerceTemporalValue(Object value, String columnType, [DABLDDO conn = null]) {
		if (null == conn) {
			conn = baseAttendance.getConnection();
		}
		return Model.coerceTemporalValue(value, columnType, conn);
	}

	static Future<DDOStatement> doSelectRS([Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = baseAttendance.getConnection();

		if (q.getTable() == null) {
			q.setTable(baseAttendance.getTableName());
		}

		return q.doSelect(conn);
	}

	Attendance setPerson([Person person = null]) {
		return setPersonRelatedByPersonId(person);
	}

	Attendance setPersonRelatedByPersonId([Person person = null]) {
		if (null == person) {
			setPersonId(null);
		} else {
			if (null == person.getId()) {
				throw new Exception('Cannot connect a Person without a id');
			}
			setPersonId(person.getId());
		}

		return this;
	}

	/**
	 * Returns a person object with a id
	 * that matches this.personId
	 */
	Future<Person> getPerson() {
		return getPersonRelatedByPersonId();
	}

	/**
	 * Returns a person object with a id
	 * that matches this.personId
	 */
	Future<Person> getPersonRelatedByPersonId() {
		Object fkValue = getPersonId();
		if (null == fkValue) {
			return null;
		}

		return basePerson.retrieveByPK(fkValue);

	}

	static Future<List<Attendance>> doSelectJoinPerson([Query q = null, String joinType = Query.LEFT_JOIN]) {
		return baseAttendance.doSelectJoinPersonRelatedByPersonId(q, joinType);
	}

	static Future<List<Attendance>> doSelectJoinPersonRelatedByPersonId([Query q = null, String joinType = Query.LEFT_JOIN]) {
		q = q != null ? q.clone() : new Query();
		List<String> columns = q.getColumns().values;
		String alias = q.getAlias();
		String thisTable = alias != null ? alias : baseAttendance.getTableName();
		if(columns.isEmpty) {
			if(alias != null) {
				for(String columnName in baseAttendance.getColumns()) {
					columns.add("${alias}.${columnName}");
				}
			} else {
				columns = baseAttendance.getColumns();
			}
		}

		String toTable = basePerson.getTableName();
		q.join(toTable, "${thisTable}.personId = ${toTable}.id", joinType);
		for (String column in basePerson.getColumns()) {
			columns.add(column);
		}
		q.setColumns(columns.asMap());

		return baseAttendance.doSelect(q, ['Person']);
	}

	static Future<List<Attendance>> doSelectJoinAll([Query q = null, String joinType = Query.LEFT_JOIN]) {
		q = q != null ? q.clone() : new Query();
		List<String> columns = q.getColumns().values;
		List<Type> classes = new List<Type>();
		String alias = q.getAlias();
		String thisTable = alias != null ? alias : baseAttendance.getTableName();
		if(columns.isEmpty) {
			if(alias != null) {
				for(String columnName in baseAttendance.getColumns()) {
					columns.add('${alias}.${columnName}');
				}
			} else {
				columns = baseAttendance.getColumns();
			}
		}

		String toTable;

		toTable = basePerson.getTableName();
		q.join(toTable, "${thisTable}.personId = ${toTable}.id", joinType);
		for(String column in basePerson.getColumns()) {
			columns.add(column);
		}
		classes.add(Person);

		q.setColumns(columns.asMap());
		return baseAttendance.doSelect(q, classes);
	}

	/**
	 * Returns true if the column values validate
	 */
	bool validate() {
		validationErrors = new List<String>();
		return validationErrors.isEmpty;
	}

	/**
	 * Creates and executess DELETE Query for this object
	 * Deletes any database rows with a primary key(s) that match Instance of 'BaseModelGenerator'
	 * NOTE/BUG: If you alter pre-existing primary key(s) before deleting, then you will be
	 * deleting based on the new primary key(s) and not the originals,
	 * leaving the original row unchanged(if it exists).  Also, since NULL isn't an accurate way
	 * to look up a row, I return if one of the primary keys is null.
	 * @return int number of records deleted
	 */
	Future<int> delete() {
		Map<String, Object> pks = getPrimaryKeyValues();
		if(pks == null || pks.isEmpty) {
			throw new Exception('This table has no primary keys');
		}
		Query q = baseAttendance.getQuery();
		for(String pk in pks.keys) {
			var pkVal = pks[pk];
			if(pkVal == null || pkVal.isEmpty) {
				throw new Exception('Cannot delete using NULL primary key.');
			}
			q.addAnd(pk, pkVal);
		}
		q.setTable(baseAttendance.getTableName());
		Completer c = new Completer();
		baseAttendance.doDelete(q, false).then((int cnt) {
			baseAttendance.removeFromPool(this);
			c.complete(cnt);
		});
		return c.future;
			
	}

	Query getForeignObjectsQuery(String foreignTable, String foreignColumn, String localColumn, [Query q = null]) {
		Object value = getColumn(localColumn);
		if (null == value) {
			throw new Exception('NULL cannot be used to match keys.');
		}

		String column = "${foreignTable}.${foreignColumn}";

		if (q != null) {
			q = q.clone();
			String alias = q.getAlias();
			if (alias != null && foreignTable == q.getTable()) {
				column = "${alias}.${foreignColumn}";
			}
		} else {
			q = new Query();
		}
		q.add(column, value);
		return q;
	}

	Model setColumnValue(String columnName, Object value, [String columnType = null]) {
		return setColumnValueByLibrary(columnName, value, 'rollcallDb_project', columnType);
	}

	Map<String, Object> getPrimaryKeyValues() {
	    Map<String, Object> vals = new Map<String, Object>();
	    InstanceMirror im = reflect(this);

		 for(String pk in getPrimaryKeys()) {
	    	var name = MirrorSystem.getName(new Symbol("_${pk}"));
	    	var symb = MirrorSystem.getSymbol(name, currentMirrorSystem().findLibrary(new Symbol('rollcallDb_project')));
	    	vals[pk] = im.getField(symb).reflectee.toString();
	    }
	    return vals;
	}
}
	
