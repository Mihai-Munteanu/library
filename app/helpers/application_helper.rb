module ApplicationHelper
  def nav_tab_class(path)
    request.path == path ? 'border-blue-500 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
  end
end
