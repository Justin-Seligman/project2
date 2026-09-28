class Address

  require_relative User

  attr_accessor :street, :city, :state, :zipCode
  def initialize(street, city, state, zipCode)
    @street = street
    @city = city
    @state = state
    @zipCode = zipCode
    

  end

  def getFullAddress()
      "#{street}, #{city}, #{state}, #{zipCode}"
  end

end