module GoogleApis
  class Api
    class Plus
      extend Base

      api "plus"
      auth_scope "https://www.googleapis.com/auth/plus.me"

    end
  end
end
