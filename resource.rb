
# Provide a nice truncated output for summaries
# from string_utils.rb
class String
  def truncate(lim, ellipsis = "...", pad = " ")
    raise "Cannot truncate to negative or zero length." if ellipsis.length >= lim
    ellipsis = "" if self.length < lim
    return (self + pad*((lim-ellipsis.length).to_f / pad.length).ceil)[0..(lim-ellipsis.length)] + ellipsis
  end
end


class Resource
  # build an object from a hash
  def initialize(name, params = {})
    @params = []
    params.each{ |p, v|
      if(p) then
        # Parse param
        param   = p.to_s.gsub(/[\s\-]/, "_")
        raise "Duplicate parameters for resource #{name}: #{param}." if @params.include? param
        val     = (v.is_a? Hash) ? Resource.new(param, v) : v

        # Assign param and add accessor
        eval("@#{param} = val")
        self.class.__send__(:attr_accessor, param)
        @params << param
      end
    }
    @name     = name
  end

  # Display contents recursively
  def describe(trunc = [17, 50], indent=0, notitle=false)
    str = "{\n"
    str = "#{" "*indent}#{@name}#{str}" if not notitle
    @params.each{|p|
      # Load the value
      val = eval("@#{p}")

      # Output the string
      str += "#{" "*indent}  #{p.truncate(trunc[0])}: "
      if val.is_a? Resource
        str += "#{val.describe(trunc, indent + 2, true)}" 
      else
        str += "#{val.to_s.truncate(trunc[1])}"
      end
      str += "\n"
    }
    str += "#{" "*indent}}"
    return str
  end
end




