require 'pg'
PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'

class DBConnection
  def self.open(dbname)
    @db = PG.connect(dbname: dbname)

    @db
  end

  def self.instance
    @db
  end

  def self.execute(*args)
    # print_query(*args)
    instance.exec(*args)
  end

  def self.execute2(*args)
    # print_query(*args)
    instance.exec(*args).fields
    
  end

  def self.execute3(*args)
    # print_query(*args)
    instance.exec_params(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  # def self.print_query(query, *interpolation_args)
  #   return unless PRINT_QUERIES

  #   puts '--------------------'
  #   puts query
  #   unless interpolation_args.empty?
  #     puts "interpolate: #{interpolation_args.inspect}"
  #   end
  #   puts '--------------------'
  # end
end
DBConnection.open("trails_demo")