defmodule Scraper do
  use Hound.Helpers

  def start(username \\ System.get_env("DOM_USERNAME"), password \\ System.get_env("DOM_PASSWORD")) do
    Driver.setup(System.get_env("DRIVER"))

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

    Driver.stop
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
end
