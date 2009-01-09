class String
  def to_permalink
    self.strip.downcase      \
      .gsub(/['"]/, '')      \
      .gsub(/(\W|\ )+/, '_') \
      .chomp('_').reverse.chomp('_').reverse
  end
end
