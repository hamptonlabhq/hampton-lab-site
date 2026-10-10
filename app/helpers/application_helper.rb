module ApplicationHelper
  # Pages that render or edit Action Text content and therefore need the trix
  # editor JS and actiontext.css. The public marketing pages don't.
  def rich_text_page?
    controller_name == "blogs"
  end

  # Every stylesheet in app/assets, minus actiontext.css on pages that don't
  # need it.
  def page_stylesheets
    rich_text_page? ? app_stylesheets_paths : app_stylesheets_paths - [ "actiontext.css" ]
  end
end
