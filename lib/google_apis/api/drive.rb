module GoogleApis
  class Api
    class Drive
      extend Base

      api "drive"
      version 2
      auth_scope "https://www.googleapis.com/auth/drive"

    end
  end
end
