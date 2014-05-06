part of rollcallDb_project;

abstract class basePerson extends ApplicationModel {

	static const String ID = 'person.id';
	static const String NAME = 'person.name';
	static const String CREATED = 'person.created';
	/**
	 * Name of the table
	 */
	static const String _tableName = 'person';

	/**
	 * Cache of objects retrieved from the database
	 */
	static Map<String, Person> _instancePool = new Map<String, Person>();

	static int _instancePoolCount = 0;

	static bool _poolEnabled = true;

	/**
	 * List of objects to batch insert
	 */
	static List<Person> _insertBatch = new List<Person>();

	static int _insertBatchSize = 500;

	/**
	 * List of all primary keys
	 */
	static final List<String> _primaryKeys = [
		'id',
	];

	/**
	 * string name of the primary key column
	 */
	static const String _primaryKey = 'id';

	/**
	 * true if primary key is an auto-increment column
	 */
	static const bool _isAutoIncrement = true;

	/**
	 * List of all fully-qualified(table.column) columns
	 */
	static final List<String> _columns = [
		basePerson.ID,
		basePerson.NAME,
		basePerson.CREATED,
	];

	/**
	 * List of all column names
	 */
	static final List<String> _columnNames = [
		'id',
		'name',
		'created',
	];

	/**
	 * map of all column types
	 */
	static final Map<String, String> _columnTypes = {
		'id': Model.COLUMN_TYPE_INTEGER,
		'name': Model.COLUMN_TYPE_LONGVARCHAR,
		'created': Model.COLUMN_TYPE_TIMESTAMP,
	};

	/**
	 * `id` INTEGER NOT NULL
	 */
	int _id;

	/**
	 * `name` LONGVARCHAR NOT NULL
	 */
	String _name;

	/**
	 * `created` TIMESTAMP NOT NULL
	 */
	String _created;
			
	/** 
	 * Gets the value of the id field
	 */
	int getId() {
		return _id;
	}

	/**
	 * Sets the value of the id field
	 */

	Person setId(Object value) {
		return setColumnValue('id', value, Model.COLUMN_TYPE_INTEGER);
	}
			
	/** 
	 * Gets the value of the name field
	 */
	String getName() {
		return _name;
	}

	/**
	 * Sets the value of the name field
	 */

	Person setName(Object value) {
		return setColumnValue('name', value, Model.COLUMN_TYPE_LONGVARCHAR);
	}
			
	/** 
	 * Gets the value of the created field
	 */
	String getCreated([String format = null]) {
		if(null == _created || null == format) {
			return _created;
		}
		if(0 == _created.indexOf('0000-00-00')) {
			return null;
		}
		DateFormat formatter = new DateFormat(format);
		return formatter.format(DateTime.parse(_created));
	}

	/**
	 * Sets the value of the created field
	 */

	Person setCreated(Object value) {
		return setColumnValue('created', value, Model.COLUMN_TYPE_TIMESTAMP);
	}

	static DABLDDO getConnection() {
		return DBManager.getConnection('rollcallDb');
	}

	static Person create() => new Person();

	static Query getQuery([Map params = null, Query q = null]) {
		q = q != null ? q.clone() : new Query();
		if(q.getTable() == null) {
			q.setTable(basePerson.getTableName());
		}

		if(params == null) {
			params = new Map();
		}

		//filters
		for(Object k in params.keys) {
			if(basePerson.hasColumn(k)) {
				q.add(k, params[k]);
			}
		}

		//order_by
		if(params.containsKey('order_by') && basePerson.hasColumn(params['order_by'])) {
			q.orderBy(params['order_by'], params.containsKey('dir') ? Query.DESC : Query.ASC);
		}

		return q;
	}

	static String getTableName() => basePerson._tableName;

	static List<String> getColumnNames() => basePerson._columnNames;

	static List<String> getColumns() => basePerson._columns;

	static Map<String, String> getColumnTypes() => basePerson._columnTypes;

	static String getColumnType(String columnName) => basePerson._columnTypes[basePerson.normalizeColumnName(columnName)];

	static List<String> _columnsCache = new List<String>();

	static bool hasColumn(String columnName) {
		
		if (null == _columnsCache || _columnsCache.isEmpty) {
			_columnsCache = basePerson._columnNames.map((String s) => s.toLowerCase()).toList();
		}
		return _columnsCache.contains(basePerson.normalizeColumnName(columnName).toLowerCase());
	}

	static List<String> getPrimaryKeys() => basePerson._primaryKeys;

	static String getPrimaryKey() => basePerson._primaryKey;

	static bool isAutoIncrement() => basePerson._isAutoIncrement;

	static String normalizeColumnName(String columnName) => Model.normalizeColumnName(columnName);

	/**
	 * Searches the database for a row with the ID(primary key) that matches
	 * the one input.
	 */
	static Future<Person> retrieveByPK(int id) {
		return basePerson.retrieveByPKs(id);
	}

	/**
	 * Searches the database for a row with the primary keys that match
	 * the ones input
	 */
	static Future<Person> retrieveByPKs(int id) {
		if(null == id) {
			return null;
		}
		if(basePerson._poolEnabled) {
			Person poolInstance = basePerson.retrieveFromPool(id);
			if(null != poolInstance) {
				return new Future.value(poolInstance);
			}
		}
		Query q = new Query();
		q.add('id', id);

		return basePerson.doSelectOne(q);
	}

	/**
	 * Searches the database for a row with a id
	 * that matches the one provided
	 */
	static Future<Person> retrieveById(int value) {
		return basePerson.retrieveByPK(value);
	}

	/**
	 * Searches the database for a row with a name
	 * that matches the one provided
	 */
	static Future<Person> retrieveByName(String value) {
		return basePerson.retrieveByColumn('name', value);
	}

	/**
	 * Searches the database for a row with a created
	 * that matches the one provided
	 */
	static Future<Person> retrieveByCreated(String value) {
		return basePerson.retrieveByColumn('created', value);
	}

	static Future<Person> retrieveByColumn(String field, Object value) {
		Query q = new Query();
		q.add(field, value);
		q.setLimit(1);
		q.order('id');
		return basePerson.doSelectOne(q);
	}

	/**
	 * Populates and returns a List of Person objects with the results of a query
	 * If the query returns no results, returns an empty List
	 */
	static Future<List<Person>> fetch(String queryString) {
		DABLDDO conn = basePerson.getConnection();
		Completer c = new Completer();
		conn.query(queryString).then((DDOStatement result) {
			c.complete(basePerson.fromResult(result, [Person]));
		});
		return c.future;
	}

	/**
	 * Returns a List of Person objects from a DDOStatement (Query result)
	 */
	static List<Person> fromResult(DDOStatement result, [List<Type> classNames = null, bool usePool = null]) {
		if (null == usePool) {
			usePool = basePerson._poolEnabled;
		}

		if(classNames == null) {
			classNames = new List<Type>();
			classNames.add(reflect(new Symbol('Person')).type.reflectedType);
		}
		List<Person> results = new List<Person>();
		for(Model m in Model.fromResult(result, classNames, usePool)) {
			results.add(m as Person);
		}

		return results;
	}

	/**
	 * Casts values of int fields to (int)
	 */
	/* Unneccessary method?
	Person castInts() {
		id = (null == id) ? null : int.parse(_id);
		return this;
	}
	*/

	/**
	 * Add (or replace) to the instance pool
	 */
	static void insertIntoPool(Person obj) {
		if(!basePerson._poolEnabled) {
			return;
		}
		if (basePerson._instancePoolCount > Model.MAX_INSTANCE_POOL_SIZE) {
			return;
		}

		basePerson._instancePool[obj.getPrimaryKeyValues().values.join('-')] = obj;
		basePerson._instancePoolCount = basePerson._instancePool.length;
	}

	/**
	 * Return the cached instance from the pool
	 */
	static Person retrieveFromPool(Object pkValue) {
		if(!basePerson._poolEnabled || null == pkValue) {
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
		if(basePerson._instancePool.containsKey(pk)) {
			basePerson._instancePool.remove(pk);
			basePerson._instancePoolCount = basePerson._instancePool.length;
		}
	}

	/**
	 * Empty the instance pool.
	 */
	static void flushPool() => basePerson._instancePool.clear();

	static void setPoolEnabled([bool b = true]) {
		basePerson._poolEnabled = b;
	}
	
	static bool getPoolEnabled() => basePerson._poolEnabled;
	
	static Future<int> doCount([Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = basePerson.getConnection();
		if (q.getTable() == null) {
			q.setTable(basePerson.getTableName());
		}
		return q.doCount(conn);
	}

	static Future<int> doDelete(Query q, [bool flushPool = true]) {
		DABLDDO conn = basePerson.getConnection();
		q = q.clone();
		if (q.getTable() == null) {
			q.setTable(basePerson.getTableName());
		}
		Future<int> result = q.doDelete(conn);
		
		if (flushPool) {
			basePerson.flushPool();
		}
		return result;
	}

	static Future<List<Person>> doSelect([Query q = null, List<Type> additionalClasses = null]) {
		if(additionalClasses == null) {
			additionalClasses = new List<Type>();
		}
		additionalClasses.insert(0, Person);
		Completer c = new Completer();
		basePerson.doSelectRS(q).then((DDOStatement result) {
			c.complete(basePerson.fromResult(result, additionalClasses));
		});
		return c.future;
	}

	static Future<Person> doSelectOne([Query q = null, List<Type> additionalClasses = null]) {
		q = q != null ? q.clone() : new Query();
		q.setLimit(1);
		Completer c = new Completer();
		basePerson.doSelect(q, additionalClasses).then((List<Person> objs) {
			c.complete(objs.isNotEmpty ? objs.first : null);
		});
		return c.future;
	}

	static Future<int> doUpdate(Map columnValues, [Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = basePerson.getConnection();

		if (q.getTable() == null) {
			q.setTable(basePerson.getTableName());
		}

		return q.doUpdate(columnValues, conn);
	}

	/**
	 * Set the maximum insert batch size, once this size is reached the batch automatically inserts.
	 */
	static int setInsertBatchSize([int size = 500]) => basePerson._insertBatchSize = size;
	
	/**
	 * Queue for batch insert
	 */
	Person queueForInsert() {
		if(basePerson._insertBatch.length >= basePerson._insertBatchSize) {
			basePerson.insertBatch();
		}

		basePerson._insertBatch.add(this);

		return this;
	}

	static Future<int> insertBatch() {
		if (basePerson._insertBatch.isEmpty) {
			return new Future.value(0);
		}

		DABLDDO conn = basePerson.getConnection();
		List<String> columns = basePerson.getColumnNames();
		String quotedTable = conn.quoteIdentifier(basePerson.getTableName());
		Object pk = basePerson.getPrimaryKey();
		if (columns.contains(pk)) {
			columns.remove(pk);
		}
	
		List values = new List();

		List<String> queryS = new List<String>();
		queryS.add('INSERT INTO ${quotedTable} (${columns.map((String s) => conn.quoteIdentifier(s)).join(', ')}) VALUES');

		List<String> placeHolders;
		StringFormat formatter = new DateFormat(conn.getTimestampFormatter());
		String now = formatter.format(new DateTime.now());
		for(Person obj in basePerson._insertBatch) {
			placeHolders = new List<String>();

			if (!obj.validate()) {
				throw new Exception('Cannot save Person with validation errors: ${obj.getValidationErrors().join(', ')}');
			}
			if (obj.isNew && basePerson.hasColumn('created') && !obj.isColumnModified('created')) {
				obj.setCreated(now);
			}

			for (String column in columns) {
				if (column == pk) {
					continue;
				}
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
			for (Person obj in basePerson._insertBatch) {
				obj.setNew(false);
				obj.resetModified();
				if(obj.hasPrimaryKeyValues()) {
					basePerson.insertIntoPool(obj);
				} else {
					obj.setDirty(true);
				}
			}
			basePerson._insertBatch.clear();
			c.complete(results.rowCount());
		});
		return c.future;
	}

	static Object coerceTemporalValue(Object value, String columnType, [DABLDDO conn = null]) {
		if (null == conn) {
			conn = basePerson.getConnection();
		}
		return Model.coerceTemporalValue(value, columnType, conn);
	}

	static Future<DDOStatement> doSelectRS([Query q = null]) {
		q = q != null ? q.clone() : new Query();
		DABLDDO conn = basePerson.getConnection();

		if (q.getTable() == null) {
			q.setTable(basePerson.getTableName());
		}

		return q.doSelect(conn);
	}

	static Future<List<Person>> doSelectJoinAll([Query q = null, String joinType = Query.LEFT_JOIN]) {
		q = q != null ? q.clone() : new Query();
		List<String> columns = q.getColumns().values;
		List<Type> classes = new List<Type>();
		String alias = q.getAlias();
		String thisTable = alias != null ? alias : basePerson.getTableName();
		if(columns.isEmpty) {
			if(alias != null) {
				for(String columnName in basePerson.getColumns()) {
					columns.add('${alias}.${columnName}');
				}
			} else {
				columns = basePerson.getColumns();
			}
		}

		String toTable;

		q.setColumns(columns.asMap());
		return basePerson.doSelect(q, classes);
	}

	/**
	 * Returns a Query for selecting attendance objects(rows) from the attendance table
	 * with a personId that matches this.id.
	 */
	Query getAttendancesRelatedByPersonIdQuery([Query q = null]) {
		return getForeignObjectsQuery('attendance', 'personId', 'id', q);
	}

	/**
	 * Returns the count of Attendance objects(rows) from the attendance table
	 * with a personId that matches this.id.
	 */
	Future<int> countAttendancesRelatedByPersonId([Query q = null]) {
		if(null == getId()) {
			return new Future.value(0);
		}
		return baseAttendance.doCount(getAttendancesRelatedByPersonIdQuery(q));
	}

	List<Attendance> _AttendancesRelatedByPersonId_c = new List<Attendance>();
			
	/**
	 * Deletes the attendance objects(rows) from the attendance table
	 * with a personId that matches this.id
	 */
	Future<int> deleteAttendancesRelatedByPersonId([Query q = null]) {
		if (null == getId()) {
			return new Future.value(0);
		}
		_AttendancesRelatedByPersonId_c.clear(); //Clear cached objects
		return baseAttendance.doDelete(getAttendancesRelatedByPersonIdQuery(q));
	}

	/**
	 * Returns a list of Attendance objects with a personId
	 * that matches this.id.
	 * When first called, this method will cache the result.
	 * After that, if this.id is not modified, the
	 * method will return the cached result instead of querying the database
	 * a second time (for performance purposes).
	 */
	Future<List<Attendance>> getAttendancesRelatedByPersonId([Query q = null]) {
		if (null == getId()) {
			return new Future.value(new List<Attendance>());
		}

		if (
			null == q &&
			getCacheResults() &&
			_AttendancesRelatedByPersonId_c.isNotEmpty &&
			!isColumnModified('id')
		) {
			return new Future.value(_AttendancesRelatedByPersonId_c);
		}
		Completer c = new Completer();
		baseAttendance.doSelect(getAttendancesRelatedByPersonIdQuery(q)).then((List<Attendance> result) {
			if (getCacheResults() && q != null) { //We can't cache when sent a Query object
				_AttendancesRelatedByPersonId_c = result;
			}
			c.complete(result);
		});

		return c.future;
	}

	/**
	 * Returns true if the column values validate
	 */
	bool validate() {
		validationErrors = new List<String>();
		if (null == getName()) {
			validationErrors.add('name must not be null');
		}
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
		Query q = basePerson.getQuery();
		for(String pk in pks.keys) {
			var pkVal = pks[pk];
			if(pkVal == null || pkVal.isEmpty) {
				throw new Exception('Cannot delete using NULL primary key.');
			}
			q.addAnd(pk, pkVal);
		}
		q.setTable(basePerson.getTableName());
		Completer c = new Completer();
		basePerson.doDelete(q, false).then((int cnt) {
			basePerson.removeFromPool(this);
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
	
