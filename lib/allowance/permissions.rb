module Allowance
  class Permissions
    def initialize(context = nil, &blk)
      @permissions = {}
      @context = context
      instance_exec(context, &blk)
    end

    def can?(verb, object = nil)
      return true if @permissions[[verb, object]]

      # If object is a resource instance, try its class
      if object.class.respond_to?(:find)
        if can?(verb, object.class)
          # See if the object is part of the defined scope
          return !scoped_model(verb, object.class).
            find(:first, :conditions => { :id => object.id }).nil?
        end
      end

      false
    end

    def can(verbs, objects = nil, scope = true, &blk)
      expand_permissions(verbs).each do |verb|
        [objects].flatten.each do |object|
          @permissions[[verb, object]] = scope  # TODO: add blk, too
        end
      end
    end

    def scoped_model(verb, model)
      if p = @permissions[[verb, model]]
        if p.is_a?(Hash)
          model.where(p)
        elsif p.is_a?(Proc)
          (p.arity == 0 ? model.instance_exec(&p) : p.call(model))
        else
          model
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
          when :view   then [:view, :index, :show]
          else p
        end
      end.flatten
    end
  end
end
