defmodule SwerveWeb.AppLive do
  use SwerveWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
