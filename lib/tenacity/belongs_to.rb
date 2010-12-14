module Tenacity
  module BelongsTo

    private

    def belongs_to_associate(association_id)
      associate_id = self.send("#{association_id}_id")
      clazz = Kernel.const_get(association_id.to_s.camelcase.to_sym)
      clazz._t_find(associate_id)
    end

    def set_belongs_to_associate(association_id, associate)
      self.send "#{association_id}_id=".to_sym, associate.id
    end

  end
end
