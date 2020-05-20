module Todoable
  class Client
    module Lists
      extend self 

    
      def all_lists
         JSON.parse(api_request(http_method: :get, endpoint: 'lists'))["lists"]
      end

      def create_list(name:)
        JSON.parse(api_request(http_method: :post, endpoint: "lists", params: list_params(name)))
      end
      
      # Weird data thing:
      # client.all_lists 
      # []
      # client.create_list(name: "test")
      # Todoable::UnprocessableEntityError ({"name"=>["has already been taken"]})

      def update_list(list_id:, name:)
        api_request(http_method: :patch, endpoint: "lists/#{list_id}", params: list_params(name))
      end

      def delete_list(list_id:)
        api_request(http_method: :delete, endpoint: "lists/#{list_id}")
      end


      private 

      def list_params(name)
       {
          "list": {
            "name": name
          }
        }
      end
    end
  end
end