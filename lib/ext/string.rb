class String
  def to_range
    dot_count = self.count('.')
    if  dot_count > 0
      elements = self.split('.' * dot_count)
      return Range.new(elements[0].to_i, elements[1].to_i)
    else
      return self
    end
  end
end