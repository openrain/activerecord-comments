module ActiveRecord::Comments::MysqlAdapter

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def mysql_comment table = table_name
      table_options = create_table_sql(table).split("\n").last
      if table_options =~ /COMMENT='/
        /COMMENT='(.*)'/.match(table_options).captures.first
      else
        nil
      end
    end

    def create_table_sql table = table_name
      connection.execute("show create table `#{ table }`").all_hashes.first['Create Table']
    end

    def column_comment column, table = table_name
      column_creation_sql = create_column_sql(column, table)
      if column_creation_sql =~ /COMMENT '/
        /COMMENT '(.*)'/.match(column_creation_sql).captures.first
      else
        nil
      end
    end

    def create_column_sql column, table = table_name
      full_table_create_sql = create_table_sql(table)
      parts = full_table_create_sql.split("\n")
      create_table = parts.shift # take off the first CREATE TABLE part
      create_table_options = parts.pop # take off the last options for the table, leaving just the columns
      sql_for_this_column = parts.find {|str| str =~ /^ *`#{ column }`/ }
      sql_for_this_column.strip! if sql_for_this_column
      sql_for_this_column
    end

  end

end

ActiveRecord::Base.send :include, ActiveRecord::Comments::MysqlAdapter
