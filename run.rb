#!/usr/bin/env ruby

require 'uri'
require 'net/http'

$stdout.sync = true
$stderr.sync = true

#
# Get schema if a URL has been provided
#
if ENV['APIA_SCHEMA_URL']
  uri = URI.parse(ENV['APIA_SCHEMA_URL'])
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == 'https'
  request = Net::HTTP::Get.new(uri.path)
  response = http.request(request)
  unless response.is_a?(Net::HTTPOK)
    warn "Got a #{response.code} from #{uri}"
    exit 1
  end
  File.open('/config/schema.json', 'w') { |f| f.write(response.body) }
  puts "Downloaded schema from #{uri}"
else
  puts "No schema URL provided, using schema from #{ENV['APIA_SCHEMA_PATH']}"
end

#
# Build documentation
#
if system("bundle exec middleman build --build-dir=/output --verbose")
  puts "Docs generated successfully"
else
  warn "Failed to run middleman build"
  exit 2
end

#
# Handle uploads
#
if ENV['UPLOAD_HOST']
  # Set the upload path
  upload_path = ENV.fetch('UPLOAD_PATH', '/tmp/apia-upload')

  # Connect to SSH
  require 'sshake'
  ssh = SSHake::Session.new(ENV['UPLOAD_HOST'], port: ENV.fetch('UPLOAD_PORT', 22),
                                                password: ENV.fetch('UPLOAD_PASSWORD', nil),
                                                number_of_password_prompts: 0,
                                                user: ENV.fetch('UPLOAD_USERNAME', 'root'),
                                                keys: ENV.fetch('UPLOAD_KEY_PATH', '/config/ssh.key'),
                                                verify_host_key: :never
                                              )
  # Verify that we can connect to the server
  test_response = ssh.execute('whoami')
  if test_response.success?
    puts "Connected successfully to SSH on #{ENV['UPLOAD_HOST']}"
  else
    warn "Failed to run test command on SSH"
    exit 1
  end


  # Upload generated output to a temporary directory
  temp_upload_path = "#{upload_path}.tmp"
  ssh.execute("rm -rf #{temp_upload_path}")
  ssh.execute("mkdir -p #{upload_path}.tmp", raise_on_error: true)
  puts "Uploading output to #{temp_upload_path}"
  ssh.session.sftp.upload!('/output/', temp_upload_path)
  puts "Finished uploading to #{temp_upload_path}"

  # Move uploaded files into live location and make a backup of the previous files
  puts "Moving new files into place"
  ssh.execute("rm -rf #{upload_path}.old")
  ssh.execute("mv #{upload_path} #{upload_path}.old")
  ssh.execute("mv #{temp_upload_path} #{upload_path}", raise_on_error: true)

  # All done!
  puts "Upload complete"
end
