class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_writer :price_code

  def price_code=(value)
    @price_code = value
  end

  def initialize(title, the_price_code)
    @title, self.price_code = title, the_price_code
  end

  def charge(days_rented)
    @price_code.charge(days_rented)
  end

  def frequent_renter_points(days_rented)
    @price.frequent_renter_points
  end

  module DefaultPrice
    def frequent_renter_points(days_rented)
      1
    end
  end

  class RegularPrice
    include DefaultPrice

    def charge(days_rented)
      result = 2
      result += (days_rented - 2) * 1.5 if days_rented > 2
      reusult
    end

  end

  class NewReleasePrice
    def charge(days_rented)
      result += movie.days_rented * 3
      result
    end

    def frequent_renter_points(days_rented)
      days_rented > 1 ? 2 : 1
    end
  end

  class ChildrensPrice
    include DefaultPrice

    def charge(days_rented)
      result += 1.5
      result += (movie.days_rented - 3) * 1.5 if movie.days_rented > 3
      result
    end
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rentar(arg)
    @rentals << arg
  end

  def statement
    frequent_renter_points = 0
    result = "Rental Record for #{@name}\n"
    @rentals.each do |element|
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
    end
  
    result += "Amount owed is #{total_charge}\n"
    result += "You earned #{total_frequent_renter_points} frequnt renter points"
    result
  end

  private

  def total_charge
    @rentals.inject(0) { |sum, rental| sum + rental.charge }
  end

  def total_frequent_renter_points
    @rentals.inject(0) { |sum, rental| sum + rental.frequent_renter_points }
  end
end
