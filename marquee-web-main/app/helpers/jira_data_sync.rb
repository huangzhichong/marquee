require File.expand_path('../jira_struct_parser', __FILE__)

class JiraDataSync

  @queue = :marquee_data_sync

  def self.perform
    @jira_parser = JiraStructParser.new File.expand_path('../../../config/jira_table_struct.yml', __FILE__)
    queries_basic = @jira_parser.parse
    skip_tables = @jira_parser.table_relation.values
    # puts "skip_tables:#{queries_basic}"
    queries_basic.each do |table, query_basic|
      next if skip_tables.include? table
      max_id = get_max_id table
      # puts "#{table}:#{query_basic} and max_id:#{max_id}"
      query = query_basic
      if @jira_parser.table_columns[table].include? 'id'
        query = @jira_parser.generate_query_condition query_basic, max_id, nil, 200 
      end
      # puts "query sql:#{query}"
      result = FndJira.connection.execute query
      save_to_mirror table, result
      process_relation result, table
    end
  end

  def self.createJob
    Resque.enqueue(JiraDataSync)
  end

  private
  def self.process_relation(parent_result, table_name)
    queries = @jira_parser.table_queries
    relation_table = @jira_parser.table_relation[table_name]
    # puts "have relation table:#{relation_table}"
    query = queries[relation_table]
#    case relation_table
#      when "changegroup": process_changegroup parent_result, relation_table, query
#      when "nodeassociation": process_nodeassociation parent_result, relation_table, query
#      else # puts("no item matched")
#    end
    if relation_table.eql? "changegroup"
      process_changegroup parent_result, relation_table, query
    elsif relation_table.eql? "nodeassociation"
      process_nodeassociation parent_result, relation_table, query
    end
  end

  def self.process_changegroup(change_item_result, table_name, query_basic)
    # puts "process changegroup"
    ChangeGroup.transaction do
      change_item_result.each do |r|
        #r[6] = groupid in change_item
       # condition = {"id" => r[6]}
       # query = @jira_parser.generate_query_condition_eq query_basic, condition, -1
       # query = query_basic
       # query << " where id = #{r[6]}"
        result = FndJira.connection.execute query_basic + " where id = #{r[6]}" 
        save_to_mirror table_name, result
        process_relation result, table_name 
      end
    end
  end
  
  def self.process_nodeassociation(change_group_result, table_name, query_basic)
    # puts "process nodeassociation"
    NodeAssociation.transaction do
      change_group_result.each do |r|
        #r[3] = issue id
        issue_id = r[3]
        result = FndJira.connection.execute query_basic + " where source_node_id = #{issue_id} or sink_node_id = #{issue_id}"
        result.each do |rs|
          sni = rs[0]
          at = rs[1]
          skni = rs[2]
          node = NodeAssociation.where(:source_node_id => sni, :association_type => at, :sink_node_id => skni)
          # puts node.inspect
          if node.empty?
            na = NodeAssociation.new
            na.source_node_id = sni
            na.association_type = at
            na.sink_node_id = skni
            na.save
          end
        end
      end
    end
  end
 
  def self.get_max_id(table_name)
    model_name = @jira_parser.table_model[table_name]
    max_id = model_name.nil? ? 0 : eval(model_name).maximum(:id) 
    max_id.nil? ? 0 : max_id
  end

  def self.save_to_mirror(table_name, result)
    model_name =  @jira_parser.table_model[table_name] 
    columns = @jira_parser.table_columns[table_name]
    result.each do |t|
      # puts "save to db with : #{t}"
      idx = 0
      if columns.include? "id"
        begin
          model_inst = eval(model_name).find t[0]
        rescue ActiveRecord::RecordNotFound
          model_inst = eval(model_name).new
        end
      else                    
        model_inst = eval(model_name).new
      end
      columns.each do |field|
        field_mq = get_mapped_field table_name, field
        model_inst.send("#{field_mq}=", t[idx])
        idx += 1
      end
      model_inst.save
    end
  end

  def self.get_mapped_field(table, field)
    field_map = @jira_parser.table_field_map[table]
    return field if field_map.nil?
    mapped  = field
    field_map.each do |item|
      if item.has_key?(field)
        mapped = item[field]
        break
      end
    end
    mapped
  end
end
