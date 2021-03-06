#!/usr/bin/env ruby

require "sinatra"
require "constantine"

set :public_folder, 'static'

CONSTANTS = Constantine::Constants.new(file="/tmp/values")

get "/" do
  developer = params[:dev] == "1"
  forms = CONSTANTS.composite_form
  dev_form = ERB.new(open("templates/add_constant_form.html.erb").read).result(binding)
  ERB.new(open("templates/index.html.erb").read).result(binding)
end

get "/json" do
  CONSTANTS.to_json
end

post "/constants" do
  c = Constantine::Constant.new(params[:name], params[:type].to_sym, params[:value])
  CONSTANTS.add_constant(c)
  CONSTANTS.save!
  '{"success":"true"}'
end

post "/constants/:constname" do
  CONSTANTS.update_constant(params[:constname], params)
  CONSTANTS.save!
  '{"success":"true"}'
end
