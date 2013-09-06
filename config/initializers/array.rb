class Array
  def humanize_join(str=',')
    if self.length > 2
      l = self.pop
      "#{self.join(', ')}, #{str} #{l}"
    elsif self.length == 2
      "#{self.shift} #{str} #{self.pop}"
    else
      self.shift
    end
  end

  def and_join
    self.humanize_join( I18n.t('and') )
  end

  def or_join
    self.humanize_join( I18n.t('or') )
  end

  def to_slug(s='-')
    self.compact.map{|v| (v || '').to_s.parameterize}.join(s)
  end

end