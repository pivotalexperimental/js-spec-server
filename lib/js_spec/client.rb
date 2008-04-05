module JsSpec
  class Client
    class << self
      def run(params={})
        data = []
        data << "selenium_host=#{CGI.escape(params[:selenium_host] || 'localhost')}"
        data << "selenium_port=#{CGI.escape((params[:selenium_port] || 4444).to_s)}"
        data << "spec_url=#{CGI.escape(params[:spec_url])}" if params[:spec_url]
        response = Net::HTTP.start(DEFAULT_HOST, DEFAULT_PORT) do |http|
          http.post('/runners/firefox', data.join("&"))
        end

        body = response.body
        if body.empty?
          puts "SUCCESS"
          return true
        else
          puts "FAILURE"
          puts body
          return false
        end
      end
    end
  end
end