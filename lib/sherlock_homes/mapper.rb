module SherlockHomes
  class Mapper

    attr_reader :raw_property, :property

    def initialize(_raw_property)
      @raw_property = _raw_property
      @property = Property.new
    end

  end
end
