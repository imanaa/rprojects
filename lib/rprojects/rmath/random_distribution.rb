module Rprojects
  module RMath
    # Factory class to create Standard
    # The class is an Abstraction of Random Variable Distributions. It is also
    # a Factory for common Random Distributions
    #==========================================================================
    class RandomDistribution
      #private
      @@registered = {}
      @@loaded = {}

      public

      def self.registered?(distribution)
        @@registered.key?(distribution)
      end

      def self.register(distribution, type)
        @@registered[distribution] = type
      end

      def self.loaded?(distribution)
        @@loaded.key?(distribution)
      end

      def self.load(distribution)
        raise(ArgumentError, "Unregistred Name: #{distribution}") unless registered?(distribution)
        unless loaded?(distribution)
          @@loaded[distribution] = eval(@@registered[distribution].to_s)
        end
      end

      def self.create(distribution, options = {})
        load(distribution) unless loaded?(distribution)
        return @@loaded[distribution].new(options)
      end

      def rand()
        raise NotImplementedError()
      end

      def expected_value()
        raise NotImplementedError()
      end

      def standard_deviation()
        raise NotImplementedError()
      end

      register(:normal, :NormalDistribution)
    end

    # Normal Distribution : Box–Muller transform
    # (http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform)
    #
    # === Parameters
    # * :mu defaults to 0
    # * :sigma defaults to 1
    #==========================================================================
    class NormalDistribution < RandomDistribution
      def initialize(options)
        @mu = options.key?(:mu)? options[:mu] : 0
        @sigma = options.key?(:sigma)? options[:sigma] : 1
        @queue = []
      end

      def rand()
        if @queue.empty?
          theta = 2 * Math::PI * Kernel.rand
          rho = Math.sqrt(-2 * Math.log(1 - Kernel.rand))
          n1 = rho * Math.cos(theta)
          n2 = rho * Math.sin(theta)
        @queue.push(@sigma * n1 + @mu)
        @queue.push(@sigma * n1 + @mu)
        end
        return @queue.pop
      end

      def expected_value()
        return @mu
      end

      def standard_deviation()
        return @sigma
      end
    end

  end
end