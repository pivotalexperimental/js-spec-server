module JsSpec
  class File
    MIME_TYPES = {
      '.js' => 'text/javascript',
      '.css' => 'text/css',
    }

    attr_reader :absolute_path, :relative_path
    
    def initialize(absolute_path, relative_path)
      @absolute_path = absolute_path
      @relative_path = relative_path
    end

    def get
      extension = ::File.extname(absolute_path)
      Server.response.headers['Content-Type'] = MIME_TYPES[extension] || 'text/html'
      ::File.read(absolute_path)
    end

    def ==(other)
      return false unless other.is_a?(File)
      absolute_path == other.absolute_path && relative_path == other.relative_path
    end
  end
end