class String
  def truncate(lim, ellipsis = "...", pad = " ")
    raise "Cannot truncate to negative or zero length" if ellipsis.length >= lim

    ellipsis = "" if self.length < lim
    return (self + pad*((lim-ellipsis.length) / pad.length).ceil)[0..(lim-ellipsis.length)] + ellipsis
  end
end

