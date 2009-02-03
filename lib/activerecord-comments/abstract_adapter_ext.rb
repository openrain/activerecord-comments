module ActiveRecord::Comments::AbstractAdapterExt

  # Get the database comment (if any) defined for a table
  #
  # ==== Parameters
  # table<~to_s>::
  #   The name of the table to get the comment for
  #
  # ==== Returns
  # String:: The comment for the given table (or nil if no comment)
  #
  # :api: public
  def comment table
    adapter = adapter_name.downcase
    database_specific_method_name = "#{ adapter }_comment"
    
    if self.respond_to? database_specific_method_name
      send database_specific_method_name, table.to_s
    else

      # try requiring 'activerecord-comments/[name-of-adapter]_adapter'
      begin

        # see if there right method exists after requiring
        require "activerecord-comments/#{ adapter }_adapter"
        if self.respond_to? database_specific_method_name
          send database_specific_method_name, table.to_s
        else
          raise ActiveRecord::Comments::UnsupportedDatabase.new("#{adapter} unsupported by ActiveRecord::Comments")
        end

      rescue LoadError
        raise ActiveRecord::Comments::UnsupportedDatabase.new("#{adapter} unsupported by ActiveRecord::Comments")
      end
    end
  end

end
