class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def charge
    result = 0

    case movie.movie.price_code
    when Movie::REGULAR
      result += 2
      result += (movie.days_rented - 2) * 1.5 if movie.days_rented > 2
    when Movie::NEW_RELEASE
      result += movie.days_rented * 3
    when Movie::CHILDRENS
      result += 1.5
      result += (movie.days_rented - 3) * 1.5 if movie.days_rented > 3
    end
    result
  end

  def frequent_renter_points
    (movie.price_code == Movie.NEW_RELEASE && days_rented > 1) ? 2 : 1
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
    frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"
    @rentals.each do |element|
      frequent_renter_points = element.frequent_renter_points
  
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
      total_amount += element.charge
    end
  
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequnt renter points"
    result
  end

  private

  def total_charge
    result = 0
    @rentals.each do |element|
      result += elemet.charge
    end
    result
  end
end
