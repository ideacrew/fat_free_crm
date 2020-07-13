# frozen_string_literal: true

module FatFreeCrm
  class AddressObserver < ActiveRecord::Observer
    observe :"::FatFreeCrm::Address"

    def before_save(item)
      set_lonlat_to_address(item)
    end

    private

    def set_lonlat_to_address(address)
      return unless address.valid?
      result = ::Google::Maps::GeocodeAddress.new.call(key: CovidMostRegistry[:google_api].setting(:google_api_key).item, address: address_into_string(address))

      if result&.success?
        address.full_address = result.value!.to_h[:results].first[:formatted_address]
        lonlat_hash = result.value!.to_h[:results].first[:geometry][:location]
        lonlat_point = create_point(lonlat_hash["lat"], lonlat_hash["lng"] )
        address.lonlat = lonlat_point
      end
    end

    def address_into_string(address)
      address[:street1].to_s + ", " + address[:street2].to_s + ", " +
      address[:city].to_s + ", " + address[:state].to_s + ", " +
      address[:country].to_s + ", " + address[:zipcode].to_s
    end

    def create_point(lat, lng)
      point = Maps::PostGis::CreatePointShape.new.call(:lat => lat, :lng => lng)
      point.success? ? point.value! : nil
    end

    ActiveSupport.run_load_hooks(:AddressObserver, self)
  end
end

