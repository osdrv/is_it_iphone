require File.join( File.dirname(__FILE__), '../lib/is_it_iphone.rb' )
require 'test/unit'

class IPhoneTestController
  include IsItIPhone
  class Request
    attr_reader :env
    attr_accessor :format
    def initialize(user_agent)
      @env = { 'HTTP_USER_AGENT' => user_agent }
    end
  end
  def test(user_agent, format=nil)
    # set up mock request object and format params
    @request = Request.new(user_agent)
    @params  = { :format => format }

    iphone_request?
  end
  
  def test_adjust_format(opts)
    @request = Request.new(opts[:user_agent])
    @params  = { :format => opts[:format] }
    @action = opts[:action]
    adjust_format_for_iphone
    @request.format.to_s == "iphone"
  end
  
private
  def request
    @request
  end
  def params
    @params
  end
  def app_root
    File.expand_path(File.dirname(__FILE__))
  end
  def action_name
    @action
  end
  def controller_views_dir
    Dir.new(
      File.expand_path(
        File.dirname(__FILE__),
        "views"
      )
    )
  end
end

class TestIsItIPhone < Test::Unit::TestCase
  PC_IE       = "IE 7 Windows Vista: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
  MAC_FIREFOX = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14"
  MAC_SAFARI  = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; en-us) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13"
  IPHONE_1_4  = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/4A102 Safari/419.3"
  IPHONE_SIM  = "Mozilla/5.0 (iPhone Simulator; U; iPhone OS 2_0 like Mac OS X; en-us) AppleWebKit/525.17 (KHTML, like Gecko) Version/3.1 Mobile/5A240d Safari/5525.7"


  def setup
    @controller = IPhoneTestController.new
  end

  def test_pc
    assert !@controller.test(PC_IE)
  end

  def test_mac_safari
    assert !@controller.test(MAC_SAFARI)
  end

  def test_mac_firefox
    assert !@controller.test(MAC_FIREFOX)
  end

  def test_iphone_1_4
    assert @controller.test(IPHONE_1_4)
  end

  def test_iphone_simulator
    assert @controller.test(IPHONE_SIM)
  end

  def test_iphone_override
    assert !@controller.test(IPHONE_1_4, "json")
  end

  def test_pc_override
    assert @controller.test(MAC_FIREFOX, "iphone")
  end
  
  def test_adjust_format_for_iphone_desktop
    assert !@controller.test_adjust_format(:action => "test", :user_agent => MAC_SAFARI), "desktop erb"
  end
  
  def test_adjust_format_for_iphone_iphone
    assert @controller.test_adjust_format(:action => "test", :user_agent => IPHONE_1_4), "iphone erb"
  end
  
  def test_adjust_format_for_iphone_desktop_haml
    assert !@controller.test_adjust_format(:action => "test2", :user_agent => MAC_SAFARI), "desktop haml"
  end
  
  def test_adjust_format_for_iphone_iphone_haml
    assert @controller.test_adjust_format(:action => "test2", :user_agent => IPHONE_1_4), "iphone haml"
  end
end

