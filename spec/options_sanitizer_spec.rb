
require_relative "../lib/marmot"


describe Marmot::OptionsSanitizer do
  it "returns default options" do
    opts = Marmot::OptionsSanitizer.sanitize({})
    opts.should include(
      :id=>"",
      :formats=>["ttf", "woff", "svg", "eotz"],
      :mode=>"optimal",
      :tt_instructor=>"default",
      :fallback=>"none",
      :fallback_custom=>100,
      :filename_suffix=>"-webfont",
      :options_subset=>"basic",
      :fix_vertical_metrics=>"Y",
      :fix_gasp=>"xy",
      :add_spaces=>"Y",
      :add_hyphens=>"Y",
      :agreement=>"Y",
      :emsquare=>2048,
      :spacing_adjustment=>0,
      :css_stylesheet=>"stylesheet.css",
      :subset_custom=>"",
      :subset_custom_range=>"",
      :dirname=>[""]
    )
  end


  it "returns options" do
    opts = Marmot::OptionsSanitizer.sanitize({
      :id => "123",
      :formats => "ttf",
      :fix_gasp => true,
      :agreement => false
    })
    opts.should include(
      :id => "123",
      :formats => ["ttf"],
      :fix_gasp => "xy"
    )
    opts.should_not include({
      :agreement => false
    })
  end

  it "doesn't accept incorrect options" do
    opts = Marmot::OptionsSanitizer.sanitize(params = {
      :agreement => "N",
      :formats => ["png","tttf"], 
      :unknown_parameter =>"test"
    })
    opts.should_not include(params)
  end


  it "accepts incorrect options as second parameter" do
    opts = Marmot::OptionsSanitizer.sanitize(params1 = {
      :agreement => "N",
      :formats => ["png","tttf"]
    }, params2 = {
      :agreement => "incorrect value 1",
      :unknown_parameter =>"incorrect value 2"
    })
    opts.should_not include(params1)
    opts.should include(params2)
  end

end

