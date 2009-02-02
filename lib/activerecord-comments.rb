$:.unshift File.dirname(__FILE__)

if defined?ActiveRecord

  class ActiveRecord::Base
    def self.create_table_sql table = table_name
      connection.execute("show create table `#{ table }`").all_hashes.first['Create Table']
    end

    # i'm sure there are lots of ways to make this explodify!  need more specs to improve this
    def self.comment table = table_name
      table_options = create_table_sql(table).split("\n").last
      if table_options =~ /COMMENT='/
        /COMMENT='(.*)'/.match(table_options).captures.first
      else
        nil
      end
    end

    def self.column_comment column, table = table_name
      column_creation_sql = create_column_sql(column, table)
      puts column_creation_sql
      if column_creation_sql =~ /COMMENT '/
        /COMMENT '(.*)'/.match(column_creation_sql).captures.first
      else
        nil
      end
    end

    def self.create_column_sql column, table = table_name
      full_table_create_sql = create_table_sql(table)
      parts = full_table_create_sql.split("\n")
      create_table = parts.shift # take off the first CREATE TABLE part
      create_table_options = parts.pop # take off the last options for the table, leaving just the columns
      sql_for_this_column = parts.find {|str| str =~ /^ *`#{ column }`/ }
      sql_for_this_column.strip! if sql_for_this_column
      sql_for_this_column
    end

    # need to inject table name into column ... not sure how else to do this  :(
    def self.columns_with_table_name *args
      columns = columns_without_table_name *args
      table = self.table_name # make table_name available as variable in instanve_eval closure
      columns.each do |column|
        column.instance_eval { @table_name = table }
      end
      columns
    end

    class << self
      alias_method_chain :columns, :table_name # this is evil!!!  how to fix?  column needs to know its table  :(
    end
  end

  # >> User.columns.first.class.superclass.instance_methods - Object.methods
  # => ["scale", "primary", "primary=", "human_name", "null", "extract_default", "default", "type_cast", "text?", "precision", "klass", "type_cast_code", "sql_type", "limit", "number?"]
  class ActiveRecord::ConnectionAdapters::Column
    attr_reader :table_name

    def comment
      ActiveRecord::Base.column_comment name, table_name
    end
  end

end
