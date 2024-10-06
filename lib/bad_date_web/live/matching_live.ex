defmodule BadDateWeb.MatchingLive do
  use BadDateWeb, :live_view

  def mount(_params, _session, socket) do
    # Initialize the socket with data (if needed)
    {:ok, assign(socket, selected: nil)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Matching</h1>
      <%= if @selected do %>
        <p>You selected: <%= @selected %></p>
      <% else %>
        <p>No selection made yet.</p>
      <% end %>
      <button phx-click="select" phx-value="Option A">Select Option A</button>
      <button phx-click="select" phx-value="Option B">Select Option B</button>
    </div>
    """
  end

  def handle_event("select", %{"value" => value}, socket) do
    {:noreply, assign(socket, selected: value)}
  end
end
