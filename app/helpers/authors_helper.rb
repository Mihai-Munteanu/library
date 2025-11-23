module AuthorsHelper
  # Returns a JavaScript back button that uses browser history
  # Falls back to default_path if history is empty or same page
  def back_button_with_fallback(default_path = root_path, text: "Back", **options)
    default_class = "bg-gray-500 hover:bg-gray-700 text-white font-medium py-2 px-4 rounded text-center transition-colors shadow-md hover:shadow-lg"
    classes = [ default_class, options[:class] ].compact.join(" ")

    options = options.except(:class)

    content_tag :button, text,
      type: "button",
      onclick: "if (document.referrer && document.referrer !== window.location.href) { window.history.back(); } else { window.location.href = '#{default_path}'; }",
      class: classes,
      **options
  end
end
