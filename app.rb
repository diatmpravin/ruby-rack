class MyApp

  @@routes_conllection = []

  def self.match(route)
  	@@routes_conllection << Route.new(route)
  end

  def map_routes(path)
  	@@routes_conllection.each do |route|
  	  if route.match(path)
  	  	return route.controller, route.action
  	  end	
  	end
  end

  def call env
  	path = env['PATH_INFO'] 
  	controller, action = map_routes(path)
  	if controller
  	  controller_name = controller_name(controller) 
  	  body = eval("#{controller_name}.new.#{action}")	
  	else
  	  body = ['Page not found']	
  	end
  	status = 200
  	header = {"Content-Type" => "text/html"}

    [status, header, body]
  end
end

class Route
  attr_accessor :path, :controller, :action

  def initialize(options)
  	path = options.keys[0]
  	x = options.values[0].split("#")
  	controller = x[0]
  	action = x[1]
  end

  def match(match_path)
  	path == match_path
  end
end

class Home < Action
  def index
  	'index'
  end	
  
  def new
  	render :text => "New user form Here"
  end
end

require 'erubis'

class Action
  def render(options)
  	@status = 200
  	if options[:text]
  	  @body = options[:text]	
  	elsif options[:file] 
  	  @body = render_erb_file(views + options[:file] + .erb)	
  	end
  end

  def reder_erb_file(file)
  	input = File.read(file)
  	eruby = Erubis::Eruby.new(input)
  	@body = eruby.result(binding())
  end
end
