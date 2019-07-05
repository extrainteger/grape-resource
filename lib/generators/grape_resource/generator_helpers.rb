module GrapeResource
  module GeneratorHelpers
    attr_accessor :attributes

    private
      def check_endpoint_or_method(args)
        @default_endpoint, custom, custom2 = [], [], []
        args.each do |arg|
          case arg.split(":").length
          when 1
            @default_endpoint << arg
          when 2
            custom << arg.split(":")
          else
            if arg.split(":")[1] == "get"
              custom2 << arg.split(":")
            end
          end
        end
        @default_endpoint
        @custom_endpoint, @custom_endpoint2 = custom.to_h, custom2
        collection_or_member
        get_endpoint_and_method_name
      end

      def collection_or_member
        collection, member = [], []
        @custom_endpoint2.each do |c2|
          collection << c2.take(2) if c2.last == "collection"
          member << c2.take(2) if c2.last == "member"
        end
        @collection, @member = collection.to_h, member.to_h
      end

      def get_endpoint_and_method_name
        @put, @post, @delete = {}, {}, {}
        @custom_endpoint.each do |k, v|
          @put[k] = v if v == "put"
          @post[k] = v if v == "post"
          @delete[k] = v if v == "delete"
        end
      end

      def model_columns_for_attributes
        name.classify.constantize.columns.reject do |column|
          column.name.to_s =~ /^(id|created_at|updated_at)$/
        end
      end

      def editable_attributes
        attributes ||= model_columns_for_attributes.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def attributes_for_params
        @entities = {}
        editable_attributes.map do |col| 
          @entities[col.name] = col.type.downcase == "text" ? "String" : col.type.capitalize
        end
        @entities
      end
  end
end
