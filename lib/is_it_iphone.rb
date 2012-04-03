# Module to be included in your ApplicationController class
# See README.txt for description of how to use this
module IsItIPhone
  # Returns true if the request USER AGENT came from an iPhone
  # (specfications from http://developer.apple.com)
  def iphone_user_agent?
    # !!(request.env['HTTP_USER_AGENT'] && request.env['HTTP_USER_AGENT'][/(Mobile\/.+Safari)/])
    !!request.user_agent.to_s.downcase.match(/iphone|ipod|ipad|mobileexplorer|android|mobile\/.+safari/)
  end

  # Returns true if the request or format parameter came from an iPhone
  def iphone_request?
    params[:format] ? params[:format] == 'iphone' : iphone_user_agent?
  end

  # Call this as a before_filter if you want to display
  # the iPhone view (i.e., index.iphone.erb) if one exists.
  # Note: According to Apple iPhone Web Developer guidelines, websites
  # should show the normal page and then give the user the option to see
  # it formatted for their iPhone.
  def adjust_format_for_iphone
    if iphone_request? && controller_views_dir.grep(/#{params[:action]}\.iphone/).any?
      request.format = :iphone
    end
  end

private

  def app_root
    ::Rails.root.to_s
  end
  
  def controller_views_dir
    Dir.new(
      File.expand_path(
        File.join(
          app_root,
          "app",
          "views",
          params[:controller]
        )
      )
    )
  end
end
