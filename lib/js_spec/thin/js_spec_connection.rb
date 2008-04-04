module Thin
  class JsSpecConnection < Connection
    def process
      # Add client info to the request env
      @request.remote_address = remote_address

      env = @request.env
      env['js_spec.connection'] = self
      status, headers, body = @app.call(env)
      unless status.to_i == 0
        send_response(status, headers, body)
      end
    rescue
      handle_error
    end

    def send_response(status, headers, body)
      @response.status, @response.headers, @response.body = status, headers, body
      @response.persistent! if @request.persistent?
      @response.each do |chunk|
        trace { chunk }
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
      log_error
      close_connection rescue nil
    end
  end
end