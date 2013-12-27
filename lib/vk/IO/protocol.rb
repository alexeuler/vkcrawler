module Vk
  module IO
    class Protocol

      # Its not json for the purpose of response by response processing (not waiting for the whole batch of repsonses)

      EOF='xHvh58vuUU'
      # data is array or string
      def self.code(data)
        res=""
        data=[data] unless data.class.name=="Array"
        data.each do |chunk|
          res << chunk
          res << "\n#{EOF}\n"
        end
        res
      end

      def self.decode(data)
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

    end
  end
end
