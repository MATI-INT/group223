class TopParent
  def method_missing(method_name)
    puts 'parent'
  end
end

class Child < TopParent
  def method_missing(method_name)
    if method_name.to_s == 'some_method'
      puts 'child'
    else
      super
    end
  end
end

obj = Child.new
obj.another_method