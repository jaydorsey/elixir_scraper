defmodule Scraper do
  use Hound.Helpers

  def start do
    # Hound.start_session(browser: "chrome", user_agent: :chrome, driver: {"prefs" => "--window-size:1280,1024"})
    # List of additional args here: http://peter.sh/experiments/chromium-command-line-switches/
    Hound.start_session(
      browser: "chrome",
      user_agent: :chrome,
      driver: %{chromeOptions: %{args: [
        "--incognito",
        "--window-size=1280,1024",
        "--window-position=0,0"
      ]}}
    )
    navigate_to "https://www.dom.com/"

    find_element(:link_text, "Other") |> click
    find_element(:id, "VA") |> click

    find_element(:id, "user") |> fill_field(System.get_env("DOM_USERNAME"))
    find_element(:id, "password") |> fill_field(System.get_env("DOM_PASSWORD"))
    find_element(:id, "SignIn") |> click

    find_element(:link_text, "Analyze Energy Usage") |> click

    page_source() |> Floki.find("#paymentsTable") |> Floki.find("tr")
  end

  def stop do
    Hound.end_session
  end
end
