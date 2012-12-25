require 'allowance/version'

module Allowance
  def permissions
    unless @permissions_defined
      define_permissions
      @permissions_defined = true
    end

    @permissions || {}
  end

  def define_permissions
    # TODO: log a warning that the subject's define_permissions needs
    #       to be overloaded.
  end

  def allowed?(verb, object = nil)
    # Allow access if there is a direct match in permissions.
    return true if permissions[[verb, object]]

    # If object is a resource instance, try its class.
    if object.class.respond_to?(:model_name)
      if allowed?(verb, object.class)
        # See if the object is part of the defined scope.
        return allowed_scope(verb, object.class).exists?(object)
      end
    end

    # Once we get here, access can't be granted.
    false
  end

  def allow(verbs, objects = nil, scope = true, &blk)
    expand_permissions(verbs).each do |verb|
      [objects].flatten.each do |object|
        @permissions ||= {}
        @permissions[[verb, object]] = scope  # TODO: add blk, too
      end
    end
  end

  def allowed_scope(verb, model)
    if p = permissions[[verb, model]]
      case p
        when Hash, String, Array then model.where(p)
        when Proc then p.call(model)
        else model.scoped
      end
    else
      model.where('1=0')   # TODO: replace this with .none once available
    end
  end

private

  def expand_permissions(*perms)
    perms.flatten.map do |p|
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

if defined?(ActiveRecord)
  require 'allowance/activerecord_ext'
end
