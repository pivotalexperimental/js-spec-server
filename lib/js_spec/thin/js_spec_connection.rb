module Thin
  class JsSpecConnection < Connection
    def process
      # Add client info to the request env
      @request.remote_address = remote_address

      env = @request.env
      env['js_spec.connection'] = self
      @response.status, @response.headers, @response.body = @app.call(env)
      send_data @response.head
      unless @response.body.empty?
        send_body @response.body
      end
    rescue
      handle_error
    end

    def send_body(rack_response)
      rack_response.each do |chunk|
        send_data chunk
      end
      # If no more request on that same connection, we close it.
      close_connection_after_writing unless persistent?
    rescue
      handle_error
    ensure
      @request.close  rescue nil
      @response.close rescue nil

      # Prepare the connection for another request if the client
      # supports HTTP pipelining (persistent connection).
      post_init if persistent?
    end

    def handle_error
      log "!! Unexpected error while processing request: #{$!.message}"
      log $!.backtrace
      log_error
      close_connection rescue nil
    end
  end
end