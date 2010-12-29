# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def markdown(content)
    return raw content.to_html
  end
  
  def show_admin_content?
    signed_in_as_admin?
  end
  
  def header_page_title
    return ' :: ' + page_title() if @my_page_title
  end
  
  def page_title
    @my_page_title.join(' : ') if @my_page_title
  end
  
  def site_group_name
    return @my_group.name unless @my_group.nil?
    return ""
  end
  
  def site_group_logo
    unless @my_group.nil?
      return  "<img src='/#{@my_group.logo_file_name}' />"
    end
    return ""
  end
  
  def site_group_logo_path
    unless @my_group.nil?
      return  @my_group.logo_file_name
    end
    return ""
  end
  
  def experiment_status_class(experiment)
    return "red-status" if experiment.expired? and experiment.open?
    return "green-status" if experiment.open?
    return "gray-status" if !experiment.open?
    return "yellow-status"
  end
  
end