module RideShare
  class Rider < Uber
    attr_reader :id, :name, :trips
    SOURCE_FILE = "support/riders.csv"

    def initialize(params)
      validate_params(params)

      @id = params[:id]
      @name = params[:name]
      @phone_number = params[:phone_number]
      @trips = params[:trips]
      @trips ||= []
    end

    def self.all
      @@all ||= super(SOURCE_FILE)
    end

    def import_trips
      @trips = Trip.by_rider(@id)
    end

    def drivers
      @trips.map { |trip| Driver.find(trip.driver_id) }
    end

    private

    def validate_params(params)
      required_attributes = [:id, :name, :phone_number]

      missing = required_attributes.select do |attribute|
        !params.keys.include?(attribute) || params[attribute].to_s.empty?
      end

      unless missing.empty?
        raise ArgumentError.new("Missing parameter(s): #{missing.join(", ")}")
      end
    end

  end
end
