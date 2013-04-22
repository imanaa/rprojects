module Rprojects
  module RMath
    module Stats
      def sample_mean(enumerable)
        s = 0
        enumerable.each { |v| s += v }
        return s / enumerable.count
      end

      # Online Implementation to calculate variance
      # See: http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
      def sample_variance(enumerable)
        n = 0
        mean = 0.0
        m2 = 0.0

        for x in enumerable
          n = n + 1
          delta = x - mean
          mean = mean + delta/n
          m2 = m2 + delta*(x - mean)
        end

        return m2/(n - 1)
      end
    end
  end
end
