require 'yaml'

class JiraStructParser
  DEFAULT_LIMIT = 10
  TABLE_NAME_FIELD = "name"
  TABLE_COLUMNS_FIELD = "columns"
  TABLE_MODEL_FIELD = "model"
  TABLE_RELATION_FIELD = "relation" 
  TABLE_FIELD_MAP_FIELD = "field_map"
  
  def initialize(struct_file)
    @jira_struct_file = struct_file
    @table_queries = {}
    @table_columns = {}
    @table_model = {}
    @table_relation = {}
    @table_field_map = {}
  end

  def parse
    #tables = load_table_struct File.expand_path('../../config/jira_table_struct.yml', __FILE__)
    tables = load_table_struct  
    tables.each do |table|
      table_name = table[TABLE_NAME_FIELD]
      columns_all = table[TABLE_COLUMNS_FIELD]
      relation_tab = table[TABLE_RELATION_FIELD]
      columns = extract_columns columns_all
      query_str = generate_query_basic table_name, columns
      @table_relation[table_name] = relation_tab if !relation_tab.nil?
      @table_columns[table_name] = columns
      @table_model[table_name] = table[TABLE_MODEL_FIELD]
      @table_queries[table_name] = query_str
      @table_field_map[table_name] = table[TABLE_FIELD_MAP_FIELD]
    end
    @table_queries
  end

  def table_field_map
    @table_field_map
  end

  def table_queries
    @table_queries
  end

  def table_columns
    @table_columns
  end

  def table_model
    @table_model
  end

  def table_relation
    @table_relation
  end

  def generate_query_basic(table_name, columns)
    query = "select distinct "
    columns.each do |column|
      query << column << ','
    end
    query = query[0..-2]
    query << " from " << table_name
  end

  # limit  -1 :query all
  def generate_query_condition(query_basic, max_id, order, limit)
    query = query_basic
    order_by = order.nil? ? "ASC" : order
    query << " where id > #{max_id.to_s} order by id #{order_by} "
    return query if limit == -1
    lim = limit.nil? ? DEFAULT_LIMIT : limit
    query << "limit #{lim.to_s}"
  end

  def generate_query_condition_eq(query_basic, condition, limit)
    query = query_basic
    puts "condition: #{condition}"
    if !condition.nil?
      query << " where "
      idx = 0
      condition.each do |con, value|
        idx += 1
        query << "#{con} = #{value} " 
        query << "and " if idx < condition.size
      end
    end
    return query if limit == -1
    lim = limit.nil? ? DEFAULT_LIMIT : limit
    query << "limit #{lim}"
  end

  def extract_columns(orig)
    columns = []
    orig.each do |column|
      columns.concat column.keys
    end
    columns
  end

  def load_table_struct
    YAML.load File.read(@jira_struct_file)
  end

end
