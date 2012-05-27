module Allowance
  class Permissions
    def initialize(context = nil, &blk)
      @permissions = {}
      @context = context
      instance_exec(context, &blk)
    end

    def can?(*args)
      if ![Symbol, Class].include?(args.last.class)
        thing = args.pop
        args.push(thing.class)
      end

      if (p = find_permission(*args))
        thing ? scoped_model(*args).find(:first, conditions: { id: thing.id }).present? : true
      else
        false
      end
    end

    def can(*args)
      options = args.pop if args.last.is_a?(Hash) || args.last.is_a?(Proc)
      object  = args.pop unless args.last.is_a?(Symbol)

      expand_permissions(args).each do |verb|
        permissions[permission_identifier(verb, object)] ||= options || true
      end
    end

    def scoped_model(*args)
      model = args.last  # TODO: check that model is a class

      if p = find_permission(*args)
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

    def find_permission(*args)
      object  = args.pop unless args.last.is_a?(Symbol)

      args.flatten.each do |verb|
        if p = permissions[permission_identifier(verb, object)]
          return p
        end
      end
      nil
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

    def permission_identifier(verb, object)
      raise "Can't use enumerables as verbs" if verb.is_a?(Enumerable)
      [verb.to_sym, object].compact
    end

    attr_reader :permissions
  end
end
