module Infoes
  module DateTimeComparable
    def <=>(other)
      date_time <=> other.date_time
    end
  end
end

