module Locomotive
  module Mounter
    module Models

      class ContentField < Base

        ## fields ##
        field :label
        field :name
        field :type,      default: :string
        field :hint
        field :position,  default: 0
        field :required,  default: false
        field :localized, default: false

        field :text_formatting

        field :class_name
        field :inverse_of
        field :order_by

        alias :target :class_name
        alias :target= :class_name=

        ## callbacks ##
        set_callback :initialize, :after, :prepare_attributes

        ## methods ##

        def prepare_attributes
          self.label ||= self.name.try(:humanize)
          self.type = self.type.to_sym
        end

        # Tell if it describes a relationship (belongs_to, many_to_many, has_many) or not.
        #
        # @return [ Boolean ] True if describing a relationship
        #
        def is_relationship?
          %w(belongs_to has_many many_to_many).include?(self.type.to_s)
        end

        # Return the content type matching the class_name / target attribute
        #
        # @return [ Object ] The matching Content Type
        #
        def klass
          (@klass ||= self.mounting_point.content_types[self.class_name]).tap do |klass|
            if klass.nil?
              raise UnknownContentTypeException.new("unknow content type #{self.class_name}")
            end
          end
        end

      end

    end
  end
end