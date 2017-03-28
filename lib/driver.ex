defmodule Driver do
  def setup("phantomjs") do
    IO.puts "Starting PhantomJS. Recommend use the chrome_driver instead"
    Hound.start_session()
    Hound.Helpers.Window.current_window_handle() |> Hound.Helpers.Window.maximize_window
  end

  def setup(_) do
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
  end


  def stop do
    Hound.end_session
  end
end
