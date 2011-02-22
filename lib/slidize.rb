require "kramdown"
require "albino"
require "haml"
require "sass"

require "slidize/slide"
require "slidize/theme"
require "slidize/version"

module Kramdown
  Options.define(:haml, String, "template.haml", "The Haml template to use")
 
  module Parser
    class SlideKramdown < Kramdown
      SLIDE_TAG = /^!(\w+)[ \t]*\n?/

      define_parser(:slide_tag, SLIDE_TAG)

      def initialize(source, options)
        super
        @block_parsers.unshift(:slide_tag)
      end

      def parse_slide_tag
        @src.pos += @src.matched_size
        
        tag = @src[1]

        case tag
        when /slide/i
          @tree.children << Element.new(:slide, "slides and stuff", nil, nil)
        when /set/i
          @tree.children << Element.new(:settings, "settings here", nil, nil)
        end
      end
    end
  end

  module Converter
    class SlideHtml < Html
      def convert_codeblock(el, indent)
        lang = el.attr["lang"]
        result = el.value
        result.chomp!
        result = Albino.new(result, lang).to_s
        result.sub!(/<pre>/, "<pre><code class=\"#{lang}\">")
        result.sub!(/<\/pre>/, "</code></pre>")

        "#{" " * indent}#{result}"
      end
    end
    
    class Deck < Base    
      def convert(el)
        slides = []
        settings = {
          "theme" => "default"
        }

        el.children.each do |e|
          case e.type
          when :slide
            slides << Slidize::Slide.new(e.attr)
          when :settings
            hash = convert_ordered_hash(e.attr)
            settings.merge!(hash)
          else
            if slides.length > 0
              slides.last.children << e
            end
          end
        end

        slides.each do |slide|
          root = Element.new(:root)
          root.children = slide.children
          slide.html = SlideHtml.convert(root).first
        end

        theme_path = Slidize.find_theme(settings["theme"])
        require File.join(theme_path, "theme.rb")
        theme = MyTheme.new(theme_path)
        theme.render(slides, settings)
      end

      private
      if RUBY_VERSION < '1.9'
        def convert_ordered_hash(ordered_hash)
          hash = Hash.new
          ordered_hash.each do |k,v|
            hash[k] = v
          end
          hash
        end
      else
        def convert_ordered_hash(ordered_hash)
          ordered_hash # Ruby 1.9 uses ordered hashes by default
        end
      end
    end
  end
end

module Slidize
  # Base directory
  def self.base_directory
    @@base_dir ||= File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  # Default theme directory
  def self.theme_directory
    File.join(self.base_directory, "themes")
  end

  # Javascript include directory
  def self.javascript_directory
    File.join(self.base_directory, "javascript")
  end

  # Find a theme in either the theme directory or the current directory, return directory of the them
  def self.find_theme(name)
    dir = File.join(self.theme_directory, name)
    if File.directory? dir
      dir
    else
      dir = File.join(Dir.pwd, name)
      if File.directory? dir
        dir
      else
        raise "Theme '#{name}' not found!"
      end
    end
  end

  # Process a deck
  def self.process(filename)
    # TODO: cache
    # read input
    markdown = File.read(filename)

    # render
    Kramdown::Document.new(markdown, :input => "SlideKramdown", :auto_ids => false, :haml => "template.haml").to_deck
  end

  # Rack application
  class Application
    def initialize(opts = {})
      @dir = Rack::File.new(Dir.pwd)
    end

    def call(env)
      request = Rack::Request.new(env)
      path_info = request.path_info
      puts ">> #{path_info}"

      if path_info == "/" or path_info == "/index.html"
        output = cache path_info do 
          puts ">> Rendering..."
          ::Slidize.process("test.md")
        end

        [200, {"Content-Type" => "text/html"}, [output]]
      else
        @dir.call(env)
      end
    end

    private
    def cache(token)
      if ENV["RACK_ENV"] == "development"
        yield
      else
        @cache ||= {}
        @cache[token] ||= yield
      end
    end
  end
end
