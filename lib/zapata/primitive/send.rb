module Zapata
  module Primitive
    class Send < Base
      def initialize(code)
        super

        if node.name == :private
          Diver.access_level = :private
        elsif node.name == :protected
          Diver.access_level = :protected
        elsif node.name == :public
          Diver.access_level = :public
        end
      end

      def to_a
        [value]
      end

      def node
        receiver, name, args = @code.to_a
        type = @code.type
        OpenStruct.new(type: type, name: name, args: args, receiver: receiver)
      end

      def raw_receiver
        Diver.dive(node.receiver).to_raw
      end

      def to_raw
        if raw_receiver.value
          Raw.new(:const_send, "#{Printer.print(raw_receiver)}.#{node.name}#{Predictor::Args.literal(node.args)}")
        else
          Predictor::Args.choose_value(node.name).to_raw
        end
      end
    end
  end
end
