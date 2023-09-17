defmodule GeolocationServiceWeb.ErrorViewTest do
  use GeolocationServiceWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render_to_string(GeolocationServiceWeb.ErrorView, "404.json", []) ==
             "{\"error\":\"not found\"}"
  end
end
