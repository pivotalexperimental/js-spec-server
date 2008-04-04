module JsSpec
  class Client
    class << self
      def run(url=nil)
        data = url ? "url=#{CGI.escape(url)}" : ""
        response = Net::HTTP.start(DEFAULT_HOST, DEFAULT_PORT) do |http|
          http.post('/runners/firefox', data)
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