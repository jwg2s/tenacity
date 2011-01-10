module Tenacity
  # Tenacity relationships on CouchRest objects require no special keys
  # defined on the object.  Tenacity will define the keys that it needs
  # to support the relationships.  Take the following class for example:
  #
  #   class Car < CouchRest::ExtendedDocument
  #     include Tenacity
  #
  #     t_has_many    :wheels
  #     t_has_one     :dashboard
  #     t_belongs_to  :driver
  #   end
  #
  # == t_belongs_to
  #
  # The +t_belongs_to+ association will define a property named after the association.
  # The example above will create a property named <tt>:driver_id</tt>
  #
  #
  # == t_has_one
  #
  # The +t_has_one+ association will not define any new properties on the object, since
  # the associated object holds the foreign key.
  #
  #
  # == t_has_many
  #
  # The +t_has_many+ association will define a property named after the association.
  # The example above will create a property named <tt>:wheels_ids</tt>
  #
  module CouchRest

    module ClassMethods #:nodoc:
      def _t_find(id)
        get(id)
      end

      def _t_find_bulk(ids)
        return [] if ids.nil? || ids.empty?

        docs = []
        result = database.get_bulk ids
        result['rows'].each do |row|
          docs << (row['doc'].nil? ? nil : create_from_database(row['doc']))
        end
        docs.reject { |doc| doc.nil? }
      end

      def _t_find_first_by_associate(property, id)
        self.send("by_#{property}", :key => id.to_s).first
      end

      def _t_find_all_by_associate(property, id)
        self.send("by_#{property}", :key => id.to_s)
      end

      def _t_initialize_has_many_association(association)
        unless self.respond_to?(association.foreign_keys_property)
          property association.foreign_keys_property, :type => [String]
          view_by association.foreign_keys_property
          after_save { |record| record.class._t_save_associates(record, association) if record.class.respond_to?(:_t_save_associates) }
        end
      end

      def _t_initialize_belongs_to_association(association)
        property_name = association.foreign_key
        unless self.respond_to?(property_name)
          property property_name, :type => String
          view_by property_name
          before_save { |record| _t_stringify_belongs_to_value(record, association) if self.respond_to?(:_t_stringify_belongs_to_value) }
        end
      end

      def _t_delete(ids, run_callbacks=true)
        docs = _t_find_bulk(ids)
        if run_callbacks
          docs.each { |doc| doc.destroy }
        else
          docs.each { |doc| database.delete_doc(doc) }
        end
      end
    end

    module InstanceMethods #:nodoc:
      def _t_reload
        new_doc = database.get(self.id)
        self.clear
        new_doc.each { |k,v| self[k] = new_doc[k] }
      end

      def _t_associate_many(association, associate_ids)
        self.send(association.foreign_keys_property + '=', associate_ids.map { |associate_id| associate_id.to_s })
      end

      def _t_get_associate_ids(association)
        self.send(association.foreign_keys_property) || []
      end

      def _t_clear_associates(association)
        self.send(association.foreign_keys_property + '=', [])
      end
    end

  end
end