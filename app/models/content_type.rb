class ContentType
  def self.all
    @types = Array.new
    Content.find_by_sql('select distinct type from contents').each do |c|
      @types<<c.type.to_s.pluralize
    end
    return @types
  end
end