module GoogleApis
  class Api
    class Storage
      extend Base

      api "storage"
      version 1
      auth_scope "https://www.googleapis.com/auth/devstorage.read_write"
      default_parameters :bucket

    end
  end
end
