class Cell < Array
  def is_gap?
    self.empty?
  end

  def set(el)
    self.clear
    self.push el
  end

  def fill(possibilities)
    self.clear
    possibilities.each { |el| self.push el}
    self
  end

  def solved?
    self.count == 1
  end

  def solved
    self.first if solved?
  end

  def value
    case self.count
    when 0
      '*'
    when 1
      self.first
    else
      '['
    end
  end
end
