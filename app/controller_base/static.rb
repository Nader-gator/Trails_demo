class Static
  attr_reader :app, :root, :file_server
  def initialize(app)
    @app = app
    @root = :assets
    @file_server = FileServer.new(@root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if self.serve?(path)
      res = self.file_server.call(env)
    else
      res = self.app.call(env)
    end
    return res
  end

  def serve?(path)
    path.index("#{self.root}")
  end
end

class FileServer
  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip',
    '.css' => 'text/css'
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    res = Rack::Response.new
    file_name = file_name(env)

    if File.exist?(file_name)
      serve_file(file_name, res)
    else
      res.status = 404
      res.write("File not found")
    end
    res
  end

 def serve_file(file_name, res)
    extension = File.extname(file_name)
    content_type = MIME_TYPES[extension]
    file = File.read(file_name)
    res["Content-type"] = content_type
    res.write(file)
  end

  def file_name(env)
    req = Rack::Request.new(env)
    path = req.path
    dir = File.dirname(__FILE__)
    File.join(dir, '..', path)
  end

end