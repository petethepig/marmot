module Marmot
  class OptionsSanitizer
    OPTIONS = {
      :id                   => [:string, ""],
      :mode                 => [:radio, "optimal", "basic", "expert"],
      :formats              => [:array, "ttf", "woff", "woff2", "svg", "eotz", "eot"],
      :tt_instructor        => [:radio, "default", "keep"],
      :fix_vertical_metrics => [:checkbox, "Y"],
      :fix_gasp             => [:checkbox, "xy"],
      :remove_kerning       => [:checkbox, nil, "Y"],
      :add_spaces           => [:checkbox, "Y"],
      :add_hyphens          => [:checkbox, "Y"],
      :fallback             => [:radio, "none", "arial", "verdana", "trebuchet", "georgia", "times", "courier", "custom"],
      :fallback_custom      => [:number, 100],
      :webonly              => [:checkbox, nil, "Y"],
      :options_subset       => [:radio, "basic", "advanced", "none"],
      :subset_range         => [:array, "macroman", "lowercase", "uppercase", "numbers", "punctuation", "currency",
                                        "typographics", "math", "altpunctuation", "accentedlower", "accentedupper",
                                        "diacriticals", "albanian", "bosnian", "catalan", "croatian", "cyrillic",
                                        "czech", "danish", "dutch", "english", "esperanto", "estonian", "faroese",
                                        "french", "german", "greek", "hebrew", "hungarian", "icelandic", "italian",
                                        "latvian", "lithuanian", "malagasy", "maltese", "norwegian", "polish",
                                        "portuguese", "romanian", "serbian", "slovak", "slovenian", "spanish",
                                        "swedish", "turkish", "ubasic", "ulatin1", "ucurrency", "upunctuation",
                                        "ulatina", "ulatinb", "ulatinaddl"],
      :subset_custom        => [:string, ""],
      :subset_custom_range  => [:string, ""],
      :base64               => [:checkbox, nil, "Y"],
      :style_link           => [:checkbox, nil, "Y"],
      :css_stylesheet       => [:string, "stylesheet.css"],
      :ot_features          => [:array, "onum", "lnum", "tnum", "pnum", "zero", "ss01", "ss02", "ss03", "ss04", "ss05"],
      :filename_suffix      => [:string, "-webfont"],
      :emsquare             => [:number, 2048],
      :spacing_adjustment   => [:number, 0],
      :agreement            => [:checkbox, "Y"]
    }

    NON_EXPERT_OPTIONS = [:id, :agreement, :mode]
    SUBSET_OPTIONS     = [:subset_range, :subset_custom, :subset_custom_range]

    #{:fix_vertical_metrics=>false, :fix_gasp=>false, :remove_kerning=>false, :add_spaces=>false, :add_hyphens=>false, :webonly=>false, :base64=>false, :style_link=>false, :agreement=>false} 
    FALSE_CHECKBOXES   = Hash[OPTIONS.collect{|k,v| [k,false] if v[0] == :checkbox }.compact]


    # Sanitize options 
    def self.sanitize options, custom_options={}
      options = options.clone
      custom_options ||= {}
      result = {}
      OPTIONS.each_pair do |key,array|
        type = array[0]
        allowed_values = array[1..999]
        user_value = options[key].nil? ? options[key.to_s] : options[key]
        
        if !user_value.nil? && OPTIONS.has_key?(key) && !NON_EXPERT_OPTIONS.include?(key)
          options[:mode] = result[:mode] = "expert" if options[:mode].nil?
        end


        if !user_value.nil? && OPTIONS.has_key?(key) && SUBSET_OPTIONS.include?(key)
          options[:options_subset] = result[:options_subset] = "advanced" if options[:options_subset].nil?
        end

        case type
        when :array
          if !user_value.kind_of?(Array)
            if user_value.kind_of?(String)
              user_value = user_value.split(",").map{|v| v.strip}
            else
              user_value = [user_value]
            end
          end

          user_value = user_value.delete_if {|val| !allowed_values.include? val }

          result[key] = user_value unless user_value.empty?
        when :number
          result[key] = (user_value || allowed_values[0]).to_i
        when :string
          result[key] = user_value || allowed_values[0]
        when :checkbox
          if user_value == true
            result[key] = allowed_values.last
          elsif user_value == false
            #nil
          else
            result[key] = allowed_values.include?(user_value) ? (user_value) : (allowed_values[0])
          end
        when :radio
          result[key] = allowed_values.include?(user_value) ? (user_value) : (allowed_values[0])
        end
      end

      result[:formats] = ["ttf", "woff", "svg", "eotz"] if result[:formats].nil?
      result[:dirname] = [result[:id]]
      result.merge!(custom_options).delete_if { |k, v| v.nil? }
    end

  end
end
