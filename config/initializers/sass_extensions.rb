module Sass::Script::Functions

  def includes(list, item)

    if list.is_a? Sass::Script::String
      my_list = [list]
    elsif list.is_a? Sass::Script::List
      my_list = list.to_a
    else
      raise ArgumentError.new("#{item.inspect} is not a list or string")
    end

    Sass::Script::Bool.new(my_list.include? item)
    
  end
  
  declare :includes, :args => [:list,:item]

end
