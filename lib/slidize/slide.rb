module Slidize
  class Slide
    attr_accessor :children
    attr_accessor :html
    attr_accessor :meta

    def initialize(meta)
      if RUBY_VERSION < '1.9'
        # Kramdown::Utils::OrderedHash for old rubies
        @meta = Hash.new
        meta.each do |k,v|
          @meta[k] = v
        end
      else
        @meta = Hash.new.merge(meta)
      end

      @children = []
    end

    def [](key)
      @meta[key]
    end
  end
end
