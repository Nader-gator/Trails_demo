require 'active_support/inflector'
require_relative 'db_connection'
require_relative 'associations'
require 'byebug'

class RecordKeeper
  extend Associations

  def self.columns
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    columns.map!(&:to_sym)
    @columns = columns
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end

      define_method("#{column}=") do |arg|
        self.attributes[column]=arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    all = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    self.parse_all(all)
  end

  def self.parse_all(results)
    arr = []
    results.each do |result_hash|
      arr << self.new(result_hash)
    end
    arr
  end

  def self.find(id)
    hash = DBConnection.execute(<<-SQL,[id])[0]
    SELECT
      *
    From
      #{self.table_name}
    WHERE
      id = $1
    SQL
    return nil unless hash
    self.new(hash)
  end

  def initialize(params = {})
    params.each do |col,val|
      raise "unknown attribute '#{col}'" unless self.class.columns.include?(col.to_sym)
      self.send("#{col}=",val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values(columns)
    columns.map do |attribute|
      self.send(attribute)
    end
  end

  def insert
    cols = self.class.columns.dup
    cols.delete(:id)
    attributes = self.attribute_values(cols)
    # qmarks= (["?"]* cols.count).join(", ")
    qmarks = []
    cols.count.times do |i|
      qmarks << "$#{i+1}"
    end
    qmarks = qmarks.join(", ")
    cols = cols.map(&:to_s).join(", ")

    insert = DBConnection.execute(<<-SQL,attributes)
      INSERT INTO
        #{self.class.table_name} (#{cols})
      values
        (#{qmarks})
      RETURNING
        id
    SQL

    self.id = insert[0]['id']
    self
  end

  def update
    cols = self.class.columns.dup
    vals = self.attribute_values(cols)
    j = 1
    # cols = cols.map.with_index {|col,i| "#{col.to_s}= $#{i+1}"}.join(", ")
    cols.each_with_index do |col,i|
      cols[i] = "#{col.to_s}= $#{i+1}"
      j = i+1
    end
    
    cols = cols.join(", ")
    DBConnection.execute(<<-SQL,[*vals, self.id])
      UPDATE
        #{self.class.table_name}
      SET
        #{cols}
      WHERE
        id = $#{j+1}
    SQL
    
  end

  def save
    self.id ? self.update : self.insert
  end

  def self.where(params)
    insert_line = params.keys.map.with_index {|param,i| "#{param}= $#{i+1}"}.join("AND ")
    result = DBConnection.execute(<<-SQL,params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{insert_line}
    SQL

    self.parse_all(result)
  end

end

class Test < RecordKeeper
end
