module SherlockHomes
  class Mapper
    autoload 'Redfin',  'sherlock_homes/mapper/redfin'
    autoload 'Trulia',  'sherlock_homes/mapper/trulia'
    autoload 'Zillow',  'sherlock_homes/mapper/zillow'

    attr_reader :raw_property, :property

    def initialize(raw_property)
      @raw_property = raw_property
      @property = Property.new
    end

  end
end
