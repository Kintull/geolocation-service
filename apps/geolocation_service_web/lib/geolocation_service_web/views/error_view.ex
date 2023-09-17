defmodule GeolocationServiceWeb.ErrorView do
  use GeolocationServiceWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".

  def render("404.json", _assigns) do
    %{error: "not found"}
  end

  def render(_template, assigns) do
    %{
      error: assigns.status,
      message: "#{inspect(assigns.reason)}"
    }
  end
end
