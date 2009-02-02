module ActiveRecord::Comments::BaseExt

  def self.included base
    base.extend ClassMethods

    base.instance_eval {
      class << self
        alias_method_chain :columns, :table_name # this is evil!!!  how to fix?  column needs to know its table  :(
      end
    }
  end

  module ClassMethods

    # Get the database comment (if any) defined for a table
    #
    # ==== Parameters
    # table<~to_s>::
    #   The name of the table to get the comment for, default is 
    #   the #table_name of the ActiveRecord::Base class this is 
    #   being called on, eg. +User.comment+
    #
    # ==== Returns
    # String:: The comment for the given table (or nil if no comment)
    #
    # :api: public
    def comment table = self.table_name
      adapter = connection.adapter_name.downcase
      database_specific_method_name = "#{ adapter }_comment"
      
      if self.respond_to? database_specific_method_name
        send database_specific_method_name, table
      else
        # update to raise an ActiveRecord::Comments::?Error
        raise "#{ adapter } unsupported by ActiveRecord::Comments"
      end
    end

    ##### MOVE BELOW *OUT* OF THIS FILE!!! ########

    def create_table_sql table = table_name
      connection.execute("show create table `#{ table }`").all_hashes.first['Create Table']
    end

    # i'm sure there are lots of ways to make this explodify!  need more specs to improve this
    def mysql_comment table = table_name
      table_options = create_table_sql(table).split("\n").last
      if table_options =~ /COMMENT='/
        /COMMENT='(.*)'/.match(table_options).captures.first
      else
        nil
      end
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

    # need to inject table name into column ... not sure how else to do this  :(
    def columns_with_table_name *args
      columns = columns_without_table_name *args
      table = self.table_name # make table_name available as variable in instanve_eval closure
      columns.each do |column|
        column.instance_eval { @table_name = table }
      end
      columns
    end

  end

end
