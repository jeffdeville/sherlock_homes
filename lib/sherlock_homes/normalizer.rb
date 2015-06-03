module SherlockHomes
  class Normalizer

    attr_reader :redfin, :zillow, :trulia, :property

    def initialize(redfin: Property.new, trulia: Property.new, zillow: Property.new)
      @redfin = redfin
      @zillow = zillow
      @trulia = trulia
      @property = Property.new
    end

    def normalize
      pick_from(source: :zillow, attributes: [:property_type])
      pick_from(source: :redfin, attributes: [:interior_features])
      pick_from(source: :redfin, store_differences: true, attributes: [
        :floors, :bedrooms, :partial_bathrooms, :full_bathrooms, :total_rooms
      ])

      #TODO to be continued ...

      property
    end

    private

    def pick_from(source: nil, attributes: [], store_differences: false)
      attributes.each do |attribute|
        property.send("#{attribute}=", eval("#{source}.#{attribute}"))
        property.sources[attribute] = source
        store_differences(attribute) if store_differences
      end
    end

    #TODO other method to merge values from different sources

    def store_differences(attribute)
      values = all_sources.collect(&attribute)
      if values.compact.uniq.size > 1
        property.differences[attribute] = {
          redfin: redfin.send(attribute),
          trulia: trulia.send(attribute),
          zillow: zillow.send(attribute)
        }
      end
    end

    def all_sources
      [redfin, zillow, trulia]
    end

  end
end
