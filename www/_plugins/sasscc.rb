require "sassc"

module Jekyll
  module SassCC
    def sasscc(input)
      engine = SassC::Engine.new(input, :syntax => :scss, :style => :compressed)
      engine.render
    end
  end
end

Liquid::Template.register_filter(Jekyll::SassCC)
