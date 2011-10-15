# Module to be included in your ApplicationController class
# See README.txt for description of how to use this
module IsItIPhone
  # Returns true if the request USER AGENT came from an iPhone
  # (specfications from http://developer.apple.com)
  def iphone_user_agent?
    !!(request.env['HTTP_USER_AGENT'] && request.env['HTTP_USER_AGENT'][/(Mobile\/.+Safari)/])
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

    if iphone_request? && File.exists?(File.join(RAILS_ROOT, 'app', 'views', self.controller_name, "#{self.action_name}.iphone.erb"))
      request.format = :iphone
    end
  end
end
