require "spec_helper"

describe AgileZen::Client do
  
  describe "#initialize" do
    it "stores the api key" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.api_key.should_not be_nil
    end
    
    it "ensures the ssl flag is false if not supplied" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.ssl.should be_false
    end
    
    it "stores the ssl flag if supplied" do
      client = AgileZen::Client.new(:api_key => 'testapikey', :ssl => true)
      client.ssl.should be_true
    end
  end
  
  describe "#has_ssl?" do
    it "checks that ssl is supported" do
      client = AgileZen::Client.new(:api_key => 'testapikey', :ssl => true)
      client.should have_ssl
    end
    
    it "checks that ssl isn't supported" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.should_not have_ssl
    end
  end
  
  describe "#has_required_authentication?" do
    it "checks that the api key exists" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.should have_required_authentication
    end
  end
  
  describe "#connection" do
    context "building the Faraday::Connection" do
      it "instantiates a Faraday::Connection" do
        client = AgileZen::Client.new(:api_key => 'testapikey')
        client.connection.should be_a(Faraday::Connection)
      end
      
      it "configures the url" do
        client = AgileZen::Client.new(:api_key => 'testapikey')
        client.connection.host.should_not be_nil
      end

      it "configures any default headers" do
        client = AgileZen::Client.new(:api_key => 'testapikey')
        client.connection.headers.should_not be_empty
      end
    end
  end
  
  describe "#connection_url" do
    it "doesn't use ssl" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.connection_url.should eq('http://agilezen.com')
    end
    
    it "uses ssl" do
      client = AgileZen::Client.new(:api_key => 'testapikey', :ssl => true)
      client.connection_url.should eq('https://agilezen.com')
    end
  end
  
  describe "#connection_headers" do
    it "sets the Accept header to JSON" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.connection_headers.should have_key(:accept)
      client.connection_headers.should have_value('application/json')
    end
    
    it "sets the X-Zen-ApiKey header" do
      client = AgileZen::Client.new(:api_key => 'testapikey')
      client.connection_headers.should have_key('X-Zen-ApiKey')
      client.connection_headers.should have_value(client.api_key)
    end
  end
  
end