module Todoable
  class Client
    module Items
      extend self 

      def create_item(list_id:, name:)
        JSON.parse(api_request(http_method: :post, endpoint: "lists/#{list_id}/items", params: params(name)))
      end


      def finish_item(list_id:, item_id:)
        api_request(http_method: :put, endpoint: "lists/#{list_id}/items/#{item_id}/finish")
      end


      def delete_item(list_id:, item_id:)
        api_request(http_method: :delete, endpoint: "lists/#{list_id}/items/#{item_id}")
      end

      private

      def params(name)
        params = {
          "item": {
           "name": name
          }
        }
      end
    end
  end
end