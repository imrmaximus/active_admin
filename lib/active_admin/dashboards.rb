module ActiveAdmin
  module Dashboards

    @@sections = {}
    mattr_accessor :sections

    class << self

      # Eval an entire block in the context of this module to build 
      # dashboards quicker. 
      #
      # Example:
      #
      #   ActiveAdmin::Dashboards.build do
      #     section "Recent Post" do
      #       # return a list of posts
      #     end
      #   end
      #
      def build(&block)
        require 'active_admin/dashboards/dashboard_controller'
        require 'active_admin/dashboards/section'

        @built = true
        module_eval(&block)
      end

      def built?
        @built == true
      end

      # Add a new dashboard section to a namespace. If no namespace is given
      # it will be added to the default namespace.
      #
      # Options include:
      #   :namespace => only display for specified namespace.
      #   :if        => specify a method or block to determine whether the section is rendered at run time.
      def add_section(name, options = {}, &block)
        namespace = options.delete(:namespace) || ActiveAdmin.application.default_namespace || :root
        self.sections[namespace] ||= [] 
        self.sections[namespace] << Section.new(namespace, name, options, &block)
        self.sections[namespace].sort!
      end
      alias_method :section, :add_section

      def sections_for_namespace(namespace)
        @@sections[namespace] || []
      end

      def clear_all_sections!
        @@sections = {}
      end

    end

  end
end
