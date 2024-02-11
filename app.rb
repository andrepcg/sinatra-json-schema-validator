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

EXAMPLE_SCHEMA = {
  "type" => "object",
  "required" => ["company_id", "account_id", "integration_connection_id", "integration_type", "integration_codename", "trigger_type"],
  "properties" => {
    "company_id" => {
      "type" => "integer"
    },
    "user_id" => {
      "type" => "integer",
      "nullable": true
    },
    "account_id" => {
      "type" => "integer"
    },
    "integration_connection_id" => {
      "type" => "integer"
    },
    "trigger_type" => {
      "type" => "string",
      "description" => "Created by automation or created manually",
      "enum" => ["automation", "manual"]
    },
    "integration_type" => {
      "type" => "string",
      "description" => "The type of integration system",
      "enum" => ["crm", "ems", "im", "automation"],
      "example" => "crm"
    },
    "integration_codename" => {
      "type" => "string",
      "description" => "Type of integration",
      "enum" => ["pipedrive", "webcrm", "mailchimp", "zoho", "salesforce", "dynamics", "slack", "zapier", "hangouts_chat", "hubspot", "active_campaign", "gong", "google_ads"],
      "example" => "salesforce"
    }
  }
}
EXAMPLE_JSON = {
  "company_id" => 1,
  "account_id" => 1,
  "integration_connection_id" => 1,
  "integration_type" => "crm",
  "integration_codename" => "salesforce",
  "trigger_type" => "manual"
}

get '/' do
  @schema = EXAMPLE_SCHEMA
  @json_data = EXAMPLE_JSON
  erb :index
end

post '/' do
  @schema = JSON.parse(params["schema"])
  @json_data = JSON.parse(params["json"])

  return redirect '/' if @schema.empty? || @json_data.empty?

  @ran_validation = true
  @errors = validation_errors(@schema, @json_data).to_a

  erb :index
end
