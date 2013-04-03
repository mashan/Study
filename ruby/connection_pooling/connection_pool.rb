require 'rubygems'
require 'active_record'

yml = <<EOS
common: &common
  adapter: mysql
  pool: 5
base:
  <<: *common
  database: test
one:
  <<: *common
  database: test
EOS

ActiveRecord::Base.configurations = YAML.load(yml)


class CreateTable < ActiveRecord::Migration
  def self.up
    unless  connection.table_exists?(:users)
      create_table :users do |t|
        t.string :name
        t.integer :name

        t.timestamps
      end
    end
  end
end

[:base, :one].each{|env|
  ActiveRecord::Base.establish_connection(env)
  ActiveRecord::Migration.verbose = false
  CreateTable.up
}


class User < ActiveRecord::Base
end

class Ua < ActiveRecord::Base
  set_table_name 'users'
  establish_connection(:one)
end

class Ub < ActiveRecord::Base
  set_table_name 'users'
  establish_connection(:one)
end

class One < ActiveRecord::Base
  establish_connection(:one)
end

class U1 < One
  set_table_name 'users'
end

class U2 < One
  set_table_name 'users'
end

[User, Ua, Ub, U1, U2].each{|klass| p klass.name + ": "  + klass.connection_pool.object_id.to_s }
p ActiveRecord::Base.connection_handler.connection_pools.keys
p Hash[ActiveRecord::Base.connection_handler.connection_pools.map{|k, v| [k, v.object_id]}]
