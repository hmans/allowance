module Allowance
  class Permissions
    def initialize
      @permissions = {}
      yield(self) if block_given?
    end

    def allowed?(verb, object = nil)
      # Allow access if there is a direct match in permissions.
      return true if @permissions[[verb, object]]

      # If object is a resource instance, try its class.
      if object.class.respond_to?(:model_name)
        if allowed?(verb, object.class)
          # See if the object is part of the defined scope.
          return scoped_model(verb, object.class).exists?(object)
        end
      end

      # Once we get here, access can't be granted.
      false
    end

    alias_method :can?, :allowed?

    def allow!(verbs, objects = nil, scope = true, &blk)
      expand_permissions(verbs).each do |verb|
        [objects].flatten.each do |object|
          @permissions[[verb, object]] = scope  # TODO: add blk, too
        end
      end
    end

    alias_method :can!, :allow!

    def method_missing(name, *args, &blk)
      if name.to_s =~ /(.+)!$/
        allow!($1.to_sym, *args, &blk)
      elsif name.to_s =~ /(.+)\?$/
        allowed?($1.to_sym, *args, &blk)
      else
        super
      end
    end

    def scoped_model(verb, model)
      if p = @permissions[[verb, model]]
        case p
          when Hash, String, Array then model.where(p)
          when Proc then p.call(model)
          else model
        end
      else
        model.where(false)
      end
    end

  private

    def expand_permissions(*permissions)
      permissions.flatten.map do |p|
        case p
          when :manage then [:manage, :index, :show, :new, :create, :edit, :update, :destroy]
          when :create then [:create, :new]
          when :read   then [:read, :index, :show]
          when :update then [:update, :edit]
          else p
        end
      end.flatten
    end
  end
end
