#Tenacity

[![Build Status](https://travis-ci.org/jwg2s/tenacity.png?branch=feature/upgrade-mongoid-3.1)](https://travis-ci.org/jwg2s/tenacity)

A database client independent way of managing relationships between models
backed by different databases.

It is sometimes necessary, or advantageous, to use more than one database in a
given application (polyglot persistence).  However, most database clients do not
support inter-database relationships.  So, writing code that manages relationships
between objects backed by different databases hasn’t been nearly as easy as
writing code to manage relationships between objects in the same database.

Tenacity aims to address this by providing a database client independent way
of managing relationships between models backed by different databases.

Tenacity is heavily based on ActiveRecord's associations, and aims to behave in
much the same way, supporting many of the same options.


### Example
```
class Car
  include MongoMapper::Document
  include Tenacity

  t_has_many :wheels
  t_has_one  :dashboard
end

class Wheel < ActiveRecord::Base
  include Tenacity

  t_belongs_to :car
end

class Dashboard < CouchRest::Model::Base
  include Tenacity
  use_database MY_COUCHDB_DATABASE

  t_belongs_to :car
end

car = Car.create

# Set the related object
dashboard = Dashboard.create({})
car.dashboard = dashboard
car.save

# Fetch related object from the respective database
car.dashboard

# Fetch related object id
car.dashboard.car_id

# Set related objects
wheel_1 = Wheel.create
wheel_2 = Wheel.create
wheel_3 = Wheel.create
wheels = [wheel_1, wheel_2, wheel_3]
car.wheels = wheels
car.save

wheel_1.car_id    # car.id

# Fetch array of related objects from the respective database
car.wheels        # [wheel_1, wheel_2, wheel_3]

# Fetch ids of related objects from the database
car.wheel_ids     # [wheel_1.id, wheel_2.id, wheel_3.id]

# Add a related object to the collection
new_wheel = Wheel.create
car.wheels << new_wheel
car.save
car.wheels        # [wheel_1, wheel_2, wheel_3, new_wheel]

```

### Additional Usage Details

The directories that contain your model classes must be in your load path in order for Tenacity to find them.

####Supported Database Clients

* ActiveRecord
* Mongoid