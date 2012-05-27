module Allowance
  class Permissions
    def initialize(context = nil, &blk)
      @permissions = {}
      @context = context
      instance_exec(context, &blk)
    end

    def can?(verb, object = nil)
      !@permissions[[verb, object]].nil?

      # if ![Symbol, Class].include?(args.last.class)
      #   thing = args.pop
      #   args.push(thing.class)
      # end

      # if (p = find_permission(*args))
      #   thing ? scoped_model(*args).find(:first, conditions: { id: thing.id }).present? : true
      # else
      #   false
      # end
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
          (p.arity == 0 ? model.instance_exec(&p) : model.call(r))
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
