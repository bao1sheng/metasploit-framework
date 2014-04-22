module Metasploit
  module Framework
    module LoginScanner

      # This class provides an in-memory representation of a conceptual Credential
      # It contains the public, private, and realm if any.
      class Credential
        include ActiveModel::Validations

        # @!attribute paired
        #   @return [Boolean] Whether BOTH a public and private are required
        attr_accessor :paired
        # @!attribute private
        #   @return [String] The private credential component (e.g username)
        attr_accessor :private
        # @!attribute password
        #   @return [String] The public credential component (e.g password)
        attr_accessor :public
        # @!attribute realm
        #   @return [String] The realm credential component (e.g domain name)
        attr_accessor :realm

        validates :paired,
          inclusion: { in: [true, false] }

        # If we have no private we MUST have a public
        validates :public,
          presence: true,
          if: "private.nil? or paired"

        # If we have no public we MUST have a private (e.g. SNMP Community String)
        validates :private,
          exclusion: { in: [nil] },
          if: "public.nil? or paired"



        # @param attributes [Hash{Symbol => String,nil}]
        def initialize(attributes={})
          attributes.each do |attribute, value|
            public_send("#{attribute}=", value)
          end
        end

      end
    end
  end
end
