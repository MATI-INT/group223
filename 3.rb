require 'yaml'

class Hash
  def symbolize_keys
    self.inject({}) do |hash, (k,v)|
      hash[k.to_sym] = v
      hash
    end
  end
end

module Outputter
  def Outputter.included(klass)
    klass.class_exec do
      define_method :initialize do
        begin
          msgs = YAML.load_file(klass.name + '.yml').symbolize_keys
        rescue Errno::ENOENT
          abort "File #{klass.name + '.yml'} does not exist..."
        else
          klass.const_set(:MESSAGES, msgs)
        end
      end

      define_method(:render) do |key, values|
        if klass::MESSAGES.has_key?(key)
          msg = klass::MESSAGES[key]
          values.each do |k,v|
            msg.gsub!(Regexp.new('\{\{' + k.to_s + '\}\}'), v.to_s)
          end
          puts msg
        end
      end

      private :render
    end
  end
end

class CustomClass
  include Outputter

  def calculate(num)
    result = num ** 2
    render(:some_info, value: result, data: num)
  end
end

class OtherClass
  include Outputter

  def display_smth
    render(:some_info, value: 5, data: 10)
  end
end

obj = OtherClass.new
obj.display_smth