module Thin
  class JsSpecConnection < Connection
    def process
      # Add client info to the request env
      @request.remote_address = remote_address

      # Process the request
      @response.status, @response.headers, @response.body = @app.call(@request.env)

      # Make the response persistent if requested by the client
      @response.persistent! if @request.persistent?

      unless @request.env['PATH_INFO'].split('/')[1] == 'servers'
        send_response
      end
    rescue
      handle_error
    end

    def send_response
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