module GoogleApis
  class Api
    class BigQuery
      extend Base

      api "bigquery"
      version 2
      auth_scope "https://www.googleapis.com/auth/bigquery"

      def select_rows(statement)
        result = jobs.query :query => statement
        types = result["schema"]["fields"].collect{|x| x["type"].downcase.to_sym}

        (result["rows"] || []).collect do |row|
          row["f"].inject([]) do |values, x|
            values << parse_value(types[values.size], x["v"])
          end
        end
      end

      def select_values(query)
        select_rows(query).collect{|x| x[0]}
      end

      def select_value(query)
        row = select_rows(query)[0]
        row[0] if row
      end

    private

      def parse_value(type, value)
        unless value == "NULL"
          case type
          when :string
            parse_string_value value
          when :integer
            parse_integer_value value
          when :float
            parse_float_value value
          when :boolean
            parse_boolean_value value
          when :timestamp
            parse_timestamp_value value
          else
            raise NotImplementedError, "Cannot parse value of type #{type.inspect}"
          end
        end
      end

      def parse_string_value(value)
        value
      end

      def parse_integer_value(value)
        value.to_i
      end

      def parse_float_value(value)
        value.to_f
      end

      def parse_boolean_value(value)
        (value == "true") || (value == "1")
      end

      def parse_timestamp_value(value)
        Time.at value.to_f.to_i
      end

    end
  end
end
