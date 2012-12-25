module Allowance
  module Subject
    def allowed?(*args)
      unless @permissions_defined
        define_permissions
        @permissions_defined = true
      end

      permissions.allowed?(*args)
    end

    def allow(*args)
      permissions.allow(*args)
    end

    def define_permissions
    end

    def permissions
      @permissions ||= Permissions.new
    end
  end
end
