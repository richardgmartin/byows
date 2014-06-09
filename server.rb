require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets.chomp) && !line.empty?  # Read the request and collect it until it's empty
    lines << line
  end
  puts lines                                        # Output the full request to stdout

  filename = lines[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')

  if File.exists?(filename)
  	client.puts "HTTP1.1 200 OK\r\n\r\n"
    response = File.read(filename)
  	
  	# if filename =~/.css$/
  	#   client.puts "Content-Type: text/css\r\n\r\n"
  	# else
  	#   client.puts "Content-Type: text/html\r\n\r\n"  
  	# end
  	
  else
    client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
    response = File.read("error.html")
  
  end	  	

  client.puts(response)
  client.close                                      # Disconnect from the client
end

