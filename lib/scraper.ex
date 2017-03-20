defmodule Scraper do
  use Hound.Helpers

  def start(username \\ System.get_env("DOM_USERNAME"), password \\ System.get_env("DOM_PASSWORD")) do
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

    if element?(:link_text, "Other") do
      find_element(:link_text, "Other") |> click
      find_element(:id, "VA") |> click
    end

    find_element(:id, "user") |> fill_field(username)
    find_element(:id, "password") |> fill_field(password)
    find_element(:id, "SignIn") |> click

    find_element(:link_text, "Analyze Energy Usage") |> click

    # Ensure payments table is loaded before we try and parse the page source
    find_element(:id, "paymentsTable")

    # [ [ Meter Read Date, Days, Usage, Average Daily Usage ].... ]
    meter_info = page_source() |> Floki.find("#paymentsTable") |> Floki.find("tr") |> Floki.find("td") |> Floki.text |> String.split |> Enum.chunk(4)

    IO.inspect(meter_info)

    Hound.end_session
  end

  # def demo do
  #   Scraper.start()
  #   Scraper.stop()
  #   # delete_cookies()
  #   :erlang.memory(:total)
  # end

  # def stop do
  #   Hound.end_session
  # end

  # def setup_session() do
  #   if System.get_env("DRIVER") == "chrome" do
  #     # List of additional args here: http://peter.sh/experiments/chromium-command-line-switches/
  #     Hound.start_session(
  #       browser: "chrome",
  #       user_agent: :chrome,
  #       driver: %{chromeOptions: %{args: [
  #         "--incognito",
  #         "--window-size=1280,1024",
  #         "--window-position=0,0"
  #       ]}}
  #     )
  #   else
  #     Hound.start_session(%{"phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36"})
  #     # This is really a PhantomJS setting, because we can explicitly set the size
  #     # relatively easily for chrome below. This should probably work with both
  #     # though
  #     #
  #     # Look for a way to explicitly set this in the setup above
  #     Hound.Helpers.Window.current_window_handle() |> Hound.Helpers.Window.maximize_window
  #   end
  # end
end
