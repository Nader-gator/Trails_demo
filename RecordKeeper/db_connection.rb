require 'pg'
require 'uri'
# PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'

class DBConnection
  ENV["RACK_ENV"] ||= 'test'
  def self.open(dbname)

    if ENV["RACK_ENV"] == "production"
      uri = URI.parse(ENV['DATABASE_URL'])
      @db = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
      @db = PG.connect(dbname: dbname )
    end
    
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
