module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def case_insensitive_like
        'LIKE'
      end
    end
    
    class PostgreSQLAdapter < AbstractAdapter
      def case_insensitive_like
        'ILIKE'
      end
    end
  end
end