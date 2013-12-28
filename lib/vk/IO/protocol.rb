module Vk
  module IO
    class Protocol

      # Its not json for the purpose of response by response processing (not waiting for the whole batch of repsonses)

      EOF='xHvh58vuUU'
      # data is array or string
      def code(data)
        res=""
        data=[data] unless data.class.name=="Array"
        data.each do |chunk|
          res << chunk
          res << "\n#{EOF}\n"
        end
        res
      end

      def decode(data)
        result=[]
        chunk=""        
        data.split("\n").each do |line|
          if line==EOF 
            result << chunk.chomp
            chunk=""
          else
            chunk << line + "\n"
          end
        end
        result
      end

      def read(args)
        args=defaults.merge args
        socket=args[:socket]
        close=args[:close]
        res=""
        while line=socket.gets do
          res << line
        end
        socket.close_read if close
        decode res
      end

      def write(args)
        args=defaults.merge args
        socket=args[:socket]
        close=args[:close]
        data=args[:data]
        socket.puts code(data)
        socket.close_write if close
      end

      def defaults
        {close: true}
      end

    end
  end
end
