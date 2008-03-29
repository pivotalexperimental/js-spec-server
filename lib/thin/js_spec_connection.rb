module Thin
  class JsSpecConnection < Connection
    def process
      if @request.env['PATH_INFO'].split('/')[1] == 'servers'
        # Add client info to the request env
        @request.remote_address = remote_address

        # Process the request
        @response.status, @response.headers, @response.body = @app.call(@request.env)
      else
        super
      end
    end
  end
end