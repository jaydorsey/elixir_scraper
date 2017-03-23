defmodule Scraper do
  use Hound.Helpers

  def start do
    # List of additional args here: http://peter.sh/experiments/chromium-command-line-switches/
    Hound.start_session(
      browser: "chrome",
      user_agent: :chrome,
      driver:
        %{
          chromeOptions:
            %{
              args: [
                "--incognito",
                "--window-size=1280,1024",
                "--window-position=0,0"
              ],
              prefs: %{
                "profile.default_content_settings.popups" => 2,
                "profile.managed_default_content_settings.geolocation" => 0
              }
            }
        }
    )
    navigate_to "https://www.dom.com/"

    # If the host machine is located in Virginia, the dom server will
    # automatically route the browser to the Virginia page. In cases where it
    # doesn't, let's switch to Virginia
    if element?(:link_text, "Other") do
      find_element(:link_text, "Other") |> click
      find_element(:id, "VA") |> click
    end

    find_element(:id, "user") |> fill_field(System.get_env("DOM_USERNAME"))
    find_element(:id, "password") |> fill_field(System.get_env("DOM_PASSWORD"))
    find_element(:id, "SignIn") |> click

    find_element(:link_text, "Analyze Energy Usage") |> click

    tmp = page_source() |>
      Floki.find("#paymentsTable") |>
      Floki.find("tr") |>
      tl |> # tl grabs the tail of a list
      Enum.at(0) |> # grabs the tr
      Floki.find("td") |>
      Enum.at(0) |>
      elem(2) |>
      Floki.text |>
      String.strip
  end

  def stop do
    Hound.end_session
  end
end
