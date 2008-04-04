Rack::Response.class_eval do
  def ready?
    status ? true : false
  end
end