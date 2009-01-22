module JsTestCore
  module Resources
    class File < ThinRest::Resource
      MIME_TYPES = {
        '.js' => 'text/javascript',
        '.css' => 'text/css',
        '.png' => 'image/png',
        '.jpg' => 'image/jpeg',
        '.jpeg' => 'image/jpeg',
        '.gif' => 'image/gif',
        }

      property :absolute_path, :relative_path

      def get
        extension = ::File.extname(absolute_path)
        content_type = MIME_TYPES[extension] || 'text/html'

        connection.terminate_after_sending do
          connection.send_head(
            200,
              'Content-Type' => content_type,
              'Last-Modified' => ::File.mtime(absolute_path).rfc822,
              'Content-Length' => ::File.size(absolute_path)
          )
          ::File.open(absolute_path) do |file|
            while !file.eof?
              connection.send_data(file.read(1024))
            end
          end
        end

        def ==(other)
          return false unless other.class == self.class
          absolute_path == other.absolute_path && relative_path == other.relative_path
        end
      end
    end
  end
end
