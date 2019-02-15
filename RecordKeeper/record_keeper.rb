require 'active_support/inflector'
require_relative 'db_connection'
require_relative 'associations'

class RecordKeeper
  extend Associations

  def self.columns
    return @columns if @columns
    columns = DBConnection.execute2(<<-SQL).first
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
    results.map do |result_hash|
      self.new(result_hash)
    end
  end

  def self.find(id)
    hash = DBConnection.execute(<<-SQL,id).first
    SELECT
      *
    From
      #{self.table_name}
    WHERE
      id = ?
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

  def attribute_values
    self.class.columns.map do |attribute|
      self.send(attribute)
    end
  end

  def insert
    cols = self.class.columns[1..-1]
    qmarks= (["?"]* cols.count).join(", ")
    cols = cols.map(&:to_s).join(", ")
    attributes = self.attribute_values[1..-1]

    insert = DBConnection.execute(<<-SQL,*attributes)
      INSERT INTO
        #{self.class.table_name} (#{cols})
      values
        (#{qmarks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns
    cols = cols.map{|col| "#{col.to_s}= ?"}.join(", ")
    vals = self.attribute_values
    DBConnection.execute(<<-SQL,*vals,self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{cols}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id ? self.update : self.insert
  end

  def self.where(params)
    insert_line = params.keys.map{|param| "#{param}= ?"}.join("AND ")

    result = DBConnection.execute(<<-SQL,*params.values)
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
