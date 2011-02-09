module Slidize
  class Theme
    DEFAULT_SETTINGS = {
      :scss_style => :compressed
    }

    def self.metaclass
      class << self
        self
      end
    end

    def self.meta_def name, &blk
      metaclass.instance_eval do
        define_method name, &blk
      end
    end

    def self.class_def name, &blk
      class_eval do
        define_method name, &blk
      end
    end

    class << self
      def get_lists
        @lists
      end

      def get_settings
        @settings
      end

      def get_properties
        @properties
      end
      
      def list(name)
        meta_def name do |val|
          @lists ||= {}
          @lists[name] ||= []
          @lists[name] << val
        end
      end

      def set(key,value)
        @settings ||= {}
        @settings[key] = value
      end
      
      def property(name)
        meta_def name do |val|
          @properties ||= {}
          @properties[name] = val
        end
      end
    end

    def initialize(theme_path)
      @theme_path = File.expand_path(theme_path)

      self.class.get_lists.each do |k, v|
        instance_variable_set("@#{k}_list", v)
      end

      self.class.get_properties.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
      
      @settings = DEFAULT_SETTINGS.merge(self.class.get_settings)
    end

    # Read and assemble javascript
    def read_javascripts
      js = @javascript_list.map do |filename|
        case filename
        when :jquery
          File.read(File.join(Slidize::javascript_directory, "jquery-1.5.min.js"))
        else
          File.read(File.join(@theme_path, filename))
        end
      end
      js.join("\n")
    end

    # Render stylesheets
    def read_stylesheets
      css = @stylesheet_list.map do |filename|
        # TODO: do not assume everything is scss but check based on filename
        stylesheet = File.read(File.join(@theme_path, filename))
        engine = Sass::Engine.new(stylesheet, :syntax => :scss, :style => @settings[:scss_style], :cache => false, :load_paths => [Dir.pwd, @theme_path, Slidize.sass_directory]) # TODO: add turbosass
        engine.render
      end
      css.join("\n")
    end

    def render(slides, settings)
      css = read_stylesheets
      js = read_javascripts

      # Render Haml
      template = File.read(File.join(@theme_path, @haml))
      engine = Haml::Engine.new(template, :format => :html5, :attr_wrapper => "\"")
      engine.render(Object.new, :slides => slides, :stylesheet => css, :javascript => js)
    end

    property :haml

    list :stylesheet
    list :javascript
  end
end
