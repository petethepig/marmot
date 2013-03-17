
require_relative "../lib/marmot"


describe Marmot::Client do
  
  before do 
    @client = Marmot::Client.new 
    @client.logger = Logger.new(STDOUT)
  end

  it "successfully performs conversion" do
    file = @client.convert File.expand_path("../test-files/Averia/Averia-Regular.ttf", __FILE__)
    File.exist?(file).should == true
    File.delete(file)
  end
  
  it "raises exception because there is no such file" do
    expect { 
      @client.convert File.expand_path("../test-files/Averia/Averia-ExtraBold.ttf", __FILE__)
    }.to raise_error
  end

  it "raises exception because file is not a font" do
    expect { 
      @client.convert File.expand_path("../test-files/Averia/FONTLOG.txt", __FILE__)
    }.to raise_error
  end

end

