module ETFlex
  # Allows assining a serialized array attribute by providing a string where
  # each array element is delimited by a comma.
  #
  module ConcatenatedAttributes

    def concatenate_attr(attribute, cast = :to_s)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def concatenated_#{attribute}=(str)
          self.#{attribute}= if str.blank? then nil else
            str.split(',').map(&:strip).map(&:#{cast})
          end
        end

        def concatenated_#{attribute}
          if #{attribute}.blank? then '' else
            #{attribute}.join(', ')
          end
        end
      RUBY
    end

  end # ConcatenatedAttributes
end # ETFlex
