require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key,:class_name,:primary_key


  def model_class
    @class_name.constantize
  end

  def table_name
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    default = {
      primary_key: :id,
      foreign_key: "#{name}_id".to_sym,
      class_name: name.to_s.camelcase
    }

    default.keys.each do |key|
      self.send("#{key}=",options[key]|| default[key])
    end

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class, options = {})
     default = {
      primary_key: :id,
      foreign_key: "#{self_class.underscore}_id".to_sym,
      class_name: name.to_s.singularize.camelcase
    }
    default.keys.each do |key|
      self.send("#{key}=",options[key]||default[key])
    end
  end
end

module Associations

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name,options)
    define_method(name) do
      options = self.class.assoc_options[name]
      foreign_key = self.send(options.foreign_key)
      options.model_class.where(options.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name,options)
    define_method(name) do
      options = self.class.assoc_options[name]
      key = self.send(options.primary_key)
      options.model_class.where(options.foreign_key => key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
    @assoc_options
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_primary_key = through_options.primary_key
      through_foreign_key = through_options.foreign_key

      source_table = source_options.table_name
      source_primary_key = source_options.primary_key
      source_foreign_key = source_options.foreign_key

      key = self.send(through_foreign_key)

      results = DBConnection.execute(<<-SQL,key)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_foreign_key} = #{source_table}.#{source_primary_key}
        WHERE 
          #{through_table}.#{through_primary_key} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
  def has_many_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_primary_key = through_options.primary_key
      through_foreign_key = through_options.foreign_key

      source_table = source_options.table_name
      source_primary_key = source_options.primary_key
      source_foreign_key = source_options.foreign_key

      key = self.send(through_primary_key)
      results = DBConnection.execute(<<-SQL,key)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{through_primary_key} = #{source_table}.#{source_foreign_key}
        WHERE
          #{through_table}.#{through_foreign_key} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
