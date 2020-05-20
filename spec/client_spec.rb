# require "bundler/setup"
# require "todoable"
# require_relative '../lib/todoable.rb'
# require_relative '../lib/todoable/items'
# require_relative '../lib/todoable/lists'

# RSpec.describe Todoable::Client do
#   let(:username) { "michael.alexander.benson@gmail.com" }
#   let(:password) { "todoable" }

#   describe "Using username and password" do
#     describe 'Lists' do
#       let(:client) { Todoable::Client.new(username: username, password: password) }

#       it "should return an array of lists" do
#         expect(client.get_lists).to be_an(Array)
#       end
#     end
#   end
# end
