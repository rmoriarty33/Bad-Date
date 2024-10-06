defmodule BadDateWeb.MatchesLive do
  use BadDateWeb, :live_view

  def mount(_params, _session, socket) do
    # Initialize the socket with data (if needed)
    {:ok, assign(socket, matches: [])}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Matches</h1>
      <ul>
        <%= for match <- @matches do %>
          <li><%= match.name %></li>
        <% end %>
      </ul>
      <button phx-click="load_matches">Load Matches</button>
    </div>
    """
  end

  def handle_event("load_matches", _params, socket) do
    # Here, you would fetch matches from your data source
    matches = [
      %{name: "Match 1"},
      %{name: "Match 2"},
      %{name: "Match 3"}
    ]

    {:noreply, assign(socket, matches: matches)}
  end
end
