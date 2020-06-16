# frozen_string_literal: true

if ENV['RAPID_SCHEMA_PATH'].nil?
  warn 'You need to specify a path to a Rapid Schema file in RAPID_SCHEMA_PATH'
  exit 1
end

if ENV['CONFIG_PATH']
  if File.file?(ENV['CONFIG_PATH'])
    require 'yaml'
    $config = YAML.load_file(ENV['CONFIG_PATH'])
  else
    warn "No config file found at #{ENV['CONFIG_PATH']}"
    exit 1
  end
else
  $config = {}
end

unless File.file?(ENV['RAPID_SCHEMA_PATH'])
  warn "No schema found at #{ENV['RAPID_SCHEMA_PATH']}"
end

$schema = RapidSchemaParser.load_from_file(ENV['RAPID_SCHEMA_PATH'])

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

set :relative_links, true
set :relative_assets, true

page '/index.html', locals: {}

%i[authentication arguments fields errors].each do |page_name|
  page "/#{page_name}.html", layout: 'layout', locals: {}
end

$schema.api.route_set.routes.each do |route|
  proxy "/routes/#{route.path}/#{route.request_method.downcase}.html", 'route.html', locals: { route: route }
end
ignore 'route.html'

def add_group(group)
  proxy "/groups/#{group.id.gsub('.', '/')}.html", 'group.html', layout: 'layout', locals: { group: group }
  group.groups.values.each { |g| add_group(g) }
end
ignore 'group.html'

$schema.api.route_set.groups.values.each do |group|
  add_group(group)
end

ignore 'scalar.html'
ignore 'enum.html'
ignore 'object.html'
ignore 'polymorph.html'
ignore 'argument_set.html'
ignore 'error.html'
ignore 'partials/*'

$schema.objects.values.each do |object|
  id = Digest::MD5.hexdigest(object.id)[0, 10]
  case object
  when RapidSchemaParser::Scalar
    proxy "/scalars/#{id}.html", 'scalar.html', locals: {scalar: object}, layout: 'layout'
  when RapidSchemaParser::Enum
    proxy "/enums/#{id}.html", 'enum.html', locals: {enum: object}, layout: 'layout'
  when RapidSchemaParser::Object
    proxy "/objects/#{id}.html", 'object.html', locals: {object: object}, layout: 'layout'
  when RapidSchemaParser::Polymorph
    proxy "/polymorphs/#{id}.html", 'polymorph.html', locals: {polymorph: object}, layout: 'layout'
  when RapidSchemaParser::ArgumentSet
    proxy "/argument_sets/#{id}.html", 'argument_set.html', locals: {argument_set: object}, layout: 'layout'
  when RapidSchemaParser::Error
    proxy "/errors/#{id}.html", 'error.html', locals: {error: object}, layout: 'layout'
  end
end

helpers do
  def schema
    $schema
  end

  def config
    $config
  end

  def id_for_url(id)
    Digest::MD5.hexdigest(id)[0, 10]
  end

  def http_method_tag(method_name)
    "<span class='httpMethodTag httpMethodTag--#{method_name.downcase}'>#{method_name.upcase}</span>"
  end

  def link_to_type(type)
    name = type.name || type.id.split('/').last
    case type
    when RapidSchemaParser::LookupArgumentSet
      link_to name, "/argument_sets/#{id_for_url(type.id)}.html", class: 'typeLink typeLink--lookupArgumentSet'
    when RapidSchemaParser::ArgumentSet
      link_to name, "/argument_sets/#{id_for_url(type.id)}.html", class: 'typeLink typeLink--argumentSet'
    when RapidSchemaParser::Object
      link_to name, "/objects/#{id_for_url(type.id)}.html", class: 'typeLink typeLink--object'
    when RapidSchemaParser::Enum
      link_to name, "/enums/#{id_for_url(type.id)}.html", class: 'typeLink typeLink--enum'
    when RapidSchemaParser::Polymorph
      link_to name, "/polymorphs/#{id_for_url(type.id)}.html", class: 'typeLink typeLink--polymorph'
    when RapidSchemaParser::Scalar
      link_to name, "/scalars/#{id_for_url(type.id)}.html", class: "typeLink typeLink--scalar typeLink--#{type.id.split('/').last.underscore}'"
    else
      name
    end
  end

  def url_tag(path, full: false)
    parts = path.split('/')
    parts = parts.map do |part|
      if part =~ /\A\:(\w+)/
        "<span class='urlTag--argument'>{#{Regexp.last_match(1)}}</span>"
      else
        part
      end
    end.join('/')
    string = "<span class='urlTag'>"
    if full
      string += "<span class='urlTag--host'>https://#{schema.host}</span>"
      string += "<span class='urlTag--namespace'>#{schema.namespace}/</span>"
    end
    string += "#{parts}</span>"
    string
  end

  def http_status_tag(status)
    case status
    when 200..299
      klass = 'httpStatusTag--success'
    when 400..499
      klass = 'httpStatusTag--clientError'
    when 500..599
      klass = 'httpStatusTag--serverError'
    else
      klass = ''
    end

    require 'rack/utils'
    name = ::Rack::Utils::HTTP_STATUS_CODES[status]
    "<span class='httpStatusTag #{klass}'>#{status} #{name}</span>"
  end

  def link_to_route_group(group)
    link_to group.name || group.id, "/groups/#{group.id.gsub('.', '/')}.html"
  end

  def route_path(route)
    "/routes/#{route.path}/#{route.request_method.downcase}.html"
  end

  def type_name(type)
    type.name || type.id.split('/').last
  end

  def fields_view(fields)
    string = String.new
    string << "<pre class='fields'>"
    string << "<span class='fields__bracket'>{</span>"
    string << "\n"
    fields.each do |field|
      string << field_output(field, spec: field.spec)
    end
    string << "<span class='fields__bracket'>}</span>"
    string << '</pre>'
    string
  end

  def field_output(field, spec: nil,  path: [])
    path += [field]
    ids = path.map(&:name)

    include = false
    include = true if spec == :all
    include = true if !include && spec.is_a?(Rapid::FieldSpec) && path.size == 1
    include = true if !include && spec.is_a?(Rapid::FieldSpec) && spec.include?(*ids[1..])

    return '' unless include

    level = path.size
    spacer = '    ' * level

    string = String.new("#{spacer}#{field.name}: ")
    type_type = field.type.class.to_s.split('::').last.underscore
    string << "<span class='fields__arrayBracket'>[</span> " if field.array?
    string << "<span class='fields__type fields__type--#{type_type}'>"
    string << link_to_type(field.type)
    if field.null?
      string << "?"
    end
    string << '</span>'

    if field.type.is_a?(RapidSchemaParser::Object)
      string << " <span class='fields__bracket'>{</span>"
      string << "\n"
      field.type.fields.each_with_index do |f, i|
        string << field_output(f, spec: spec, path: path)
      end
      string << "#{spacer}<span class='fields__bracket'>}</span>"
    end
    string << " <span class='fields__arrayBracket'>]</span>" if field.array?

    string << "\n"

    string
  end

  def add_full_stop(text)
    return nil if text.nil?
    return text if text =~ /\.\z/

    text + "."
  end
end

activate :directory_indexes

configure :build do
  activate :minify_css
  #activate :minify_javascript
end
