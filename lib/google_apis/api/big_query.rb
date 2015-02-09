module GoogleApis
  class Api
    class BigQuery
      extend Base

      api "bigquery"
      version 2
      auth_scope "https://www.googleapis.com/auth/bigquery"

    end
  end
end
