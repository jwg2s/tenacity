class ActiveRecordHasOneTarget < ActiveRecord::Base
  include Tenacity

  t_belongs_to :active_record_object
  t_belongs_to :couch_rest_object
  t_belongs_to :mongo_mapper_object
  require_mongoid { t_belongs_to :mongoid_object }
end