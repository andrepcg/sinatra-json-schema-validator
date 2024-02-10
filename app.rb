require 'sinatra'
require 'json_schemer'
require 'json'

def validation_errors(schema, input)
    schemer = JSONSchemer.openapi({
    'openapi' => '3.0.0',
    'components' => {
      'schemas' => {
        'Detail' => schema
      }
    }
  }).schema('Detail')

  schemer.validate(input)
end

get '/' do
  erb :index
end

post '/' do
  @schema = JSON.parse(params["schema"])
  @json_data = JSON.parse(params["json"])

  return erb :index if @schema.empty? || @json_data.empty?

  @ran_validation = true
  @errors = validation_errors(@schema, @json_data).to_a

  erb :index
end