require 'json'
require 'httmultiparty'
require 'logger'

module Marmot
  class Client
    include HTTMultiParty

    base_uri 'www.fontsquirrel.com'
    attr_accessor :logger
    attr_reader   :params
    @@headers_set = false

    def initialize
      logger = ::Logger.new(STDOUT)
      logger.close
    end

    # Convert a font file to a webfont kit
    #
    # @param [String] input_io Input IO. Examples: File.new("font.ttf"), STDOUT
    #
    # @param [Hash] options Options
    #
    # @option options 
    #   [String]   :output_io          
    #   Output IO
    #   Default is a File with the name like "webfontkit-20130312-200144.zip"
    #
    # @option options 
    #   [Hash]     :custom_options        
    #   Options that will bypass sanitization. Make sure you know what you do before trying it out.
    #
    # @option options [Array or String]  :formats              
    #   Allowed values are: "ttf", "woff", "svg", "eotz", "eot". Default is ["ttf","woff","svg","eotz"]
    #
    # @option options 
    #   [String]   :mode                 
    #   Generator mode: "optimal", "basic", "expert". Default is "optimal"
    #
    # @option options 
    #   [String]   :tt_instructor        
    #   Truetype hinting: "default", "keep"
    #
    # @option options 
    #   [Boolean]  :fix_vertical_metrics 
    #   Rendering option. Fix Vertical Metrics (Normalize across browsers). Default is true
    #
    # @option options 
    #   [Boolean]  :fix_gasp       
    #   Rendering option. Fix GASP Table (Better DirectWrite Rendering). Default is true
    #
    # @option options 
    #   [Boolean]  :remove_kerning  
    #   Rendering option. Remove Kerning (Strip kerning data). Default is false
    #
    # @option options 
    #   [Boolean]  :add_spaces       
    #   Fix missing glyphs option. Fix spaces. Default is true
    #
    # @option options 
    #   [Boolean]  :add_hyphens    
    #   Fix missing glyphs option. Fix hyphens. Default is true
    #
    # @option options 
    #   [String]   :fallback             
    #   X-height matching: "none", "arial", "verdana", "trebuchet", "georgia", "times", "courier", "custom"
    #
    # @option options 
    #   [String]   :fallback_custom      
    #   Custom x-height matching, in percents. Default is "100%". Only applies when :fallback is "custom"
    #
    # @option options 
    #   [Boolean]  :webonly    
    #   Disable desktop use. Default is false
    #    
    # @option options 
    #   [String]   :options_subset       
    #   Subsetting options: "basic", "advanced", "none". Default is "basic"
    #
    # @option options 
    #   [Array]    :subset_range        
    #   Custom subsetting options. Only applies when :options_subset is "advanced". 
    #   Allowed values are: "macroman", "lowercase", "uppercase", "numbers", "punctuation", "currency", 
    #   "typographics", "math", "altpunctuation", "accentedlower", "accentedupper", "diacriticals", 
    #   "albanian", "bosnian", "catalan", "croatian", "cyrillic", "czech", "danish", "dutch", "english", 
    #   "esperanto", "estonian", "faroese", "french", "german", "greek", "hebrew", "hungarian", "icelandic", 
    #   "italian", "latvian", "lithuanian", "malagasy", "maltese", "norwegian", "polish", "portuguese", 
    #   "romanian", "serbian", "slovak", "slovenian", "spanish", "swedish", "turkish", "ubasic", "ulatin1", 
    #   "ucurrency", "upunctuation", "ulatina", "ulatinb", "ulatinaddl"
    #
    # @option options 
    #   [String]   :subset_custom        
    #   Single characters. Only applies when :options_subset is "advanced". Default is ""
    #
    # @option options 
    #   [String]   :subset_custom_range  
    #   Unicode Ranges. Only applies when :options_subset is "advanced". 
    #   Comma separated values. Can be single hex values and/or ranges separated with hyphens. 
    #   Example: "0021-007E,00E7,00EB,00C7,00CB"
    #
    # @option options 
    #   [Boolean]  :base64               
    #   CSS option. Base64 encode (Embed font in CSS). Default is false
    #
    # @option options 
    #   [Boolean]  :style_link           
    #   CSS option. Style link (Family support in CSS). Default is false
    #
    # @option options 
    #   [String]   :css_stylesheet       
    #   CSS Filename. Default is "stylesheet.css"
    #
    # @option options 
    #   [String]   :ot_features         
    #   OpenType Options. If the features are available, the generator will fold them into the font.
    #   Allowed values: "onum", "lnum", "tnum", "pnum", "zero", "ss01", "ss02", "ss03", "ss04", "ss05"
    #
    # @option options 
    #   [String]   :filename_suffix      
    #   Filename suffix. Default is "-webfont"
    #
    # @option options 
    #   [String]   :emsquare   
    #   Em Square Value. In units of the em square. Default is 2048
    #
    # @option options 
    #   [String]   :spacing_adjustment   
    #   Adjust Glyph Spacing. In units of the em square. Default is 0
    #
    # @option options 
    #   [Boolean]  :agreement            
    #   Agreement option. The fonts You're uploading are legally eligible for web embedding. Default is true.
    #
    # @see http://www.fontsquirrel.com/tools/webfont-generator more info about parameters @ www.fontsquirrel.com
    # @return [String]  
    def convert input_io, options={}
      @exception = nil
      #1
      iam "Retrieving cookies... ", false do
        response = self.class.get '/tools/webfont-generator'
        @cookies = (response.headers.get_fields("Set-Cookie") || []).join(";")
        fail "Failed to retrieve cookies" if @cookies.empty? 
        self.class.headers({"Cookie" => @cookies})
        @@headers_set = true
        response
      end unless @@headers_set

      #2
      iam "Uploading font... " do
        response = self.class.post '/uploadify/fontfacegen_uploadify.php', :query => {
          "Filedata"    => File.new(input_io)
        }
        @path_data = response.body
        @id, @original_filename = @path_data.split("|")
        fail "Failed to upload the file. Is it a valid font?" if @id.nil? || @original_filename.nil?
        response
      end

      #3
      iam "Confirming upload... " do
        response = self.class.post "/tools/insert", :query => {
          "original_filename"  => @original_filename,
          "path_data"          => @path_data
        }
        json = JSON.parse response.body
        fail (json["message"] || "Failed to confirm the upload. Is it a valid font?") if !json["name"] || !json["id"]
        response
      end

      #4
      iam "Generating webfont... " do
        custom_options = options.delete :custom_options
        options[:id] = @id
        @params = OptionsSanitizer.sanitize(options, custom_options)
        logger.debug "HTTP Params:\n#{@params.collect{|k,v| "#{k}: #{v.inspect}" }.join("\n")}"
        response = self.class.post "/tools/generate", :query => @params
        fail "Failed to generate webfont kit" if !response.body.empty?
        response
      end

      #5
      counter = 0
      while response = self.class.get("/tools/progress/#{@id}") do 
        p = JSON.parse(response.body)["progress"].to_i
        logger.info "Progress: #{p} "
        if p == 100
          break
        elsif p == 0
          fail "Progress timeout" if (counter += 1) > 10
        end
        sleep 2        
      end

      #6
      iam "Downloading fonts... ", false do
        response = self.class.post "/tools/download", :query => @params
      end

      #7
      if !options[:output_io]
        filename = response.headers["Content-Disposition"].gsub(/attachment; filename=\"(.*)\"/,'\1')
        options[:output_io] = File.new(filename, "wb")
      end
      options[:output_io] << response.response.body

    end

    protected

    def iam desc, log_body=true
      logger.info desc
      response = yield
      logger.info response.message
      logger.debug "Response body: #{response.body}" if log_body 
      if @exception
        raise @exception
      end
    end

    def fail str
      @exception = MarmotError.new str
    end

  end
end
