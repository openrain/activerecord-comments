module ActiveRecord::Comments::MysqlAdapterAdapter
  # adding to avoid extra lookups of 'show create table'. This gets really slow esp. if the table has many attributes.
  # perhaps there's a better way to do this, as I am not a big fan of class attributes!
  def self.included base
    base.cattr_accessor :create_table_sqls
    base.create_table_sqls = {}
  end

  # MySQL implementation of ActiveRecord::Comments::BaseExt#comment
  def mysql_comment table
    table_options = create_table_sql(table).split("\n").last
    if table_options =~ /COMMENT='/
      /COMMENT='(.*)'/.match(table_options).captures.first
    else
      nil
    end
  end

  # MySQL implementation of ActiveRecord::Comments::BaseExt#column_comment
  def mysql_column_comment column, table
    column_creation_sql = create_column_sql(column, table)
    if column_creation_sql =~ /COMMENT '/
      /COMMENT '(.*)'/.match(column_creation_sql).captures.first
    else
      nil
    end
  end

  private

  # Returns the SQL used to create the given table
  #
  # ==== Parameters
  # table<~to_s>::
  #   The name of the table to get the 'CREATE TABLE' SQL for
  #
  # ==== Returns
  # String:: the SQL used to create the table
  #
  # :api: private

  def create_table_sql table = table_name
    if self.class.create_table_sqls[table]
      return self.class.create_table_sqls[table]
    else
      self.class.create_table_sqls[table] = execute("show create table `#{ table }`").all_hashes.first['Create Table']  
    end    
  end

  # Returns the SQL used to create the given column for the given table
  #
  # ==== Parameters
  # column<~to_s>::
  #   The name of the column to get the creation SQL for
  #
  # table<~to_s>::
  #   The name of the table to get the 'CREATE TABLE' SQL for
  #
  # ==== Returns
  # String:: the SQL used to create the column
  #
  # :api: private
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

ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, ActiveRecord::Comments::MysqlAdapterAdapter
