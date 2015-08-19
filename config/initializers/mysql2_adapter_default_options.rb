require 'active_record/connection_adapters/abstract_mysql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class Mysql2Adapter < AbstractMysqlAdapter
      # If we don't have options set, add 'ENGINE=MyISAM'
      def create_table(table_name, options = {}) #:nodoc:
        super(table_name, options.reverse_merge(options: "ENGINE=MyISAM"))
      end
    end
  end
end
