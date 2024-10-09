defmodule BadDateWeb.MatchesLive do
  use BadDateWeb, :live_view
  alias BadDate.Repo
  alias BadDate.Accounts.User  # Adjusted to match the likely schema module

  def mount(_params, session, socket) do
    current_user_id = session["user_id"]  # Get the current user's ID from the session
    IO.inspect(current_user_id, label: "Current User ID")  # Debug log

    all_users = Repo.all(User)  # Fetch all users

    users =
      if current_user_id do
        # Reject the current user from the list
        all_users
        |> Enum.reject(fn user -> user.id == String.to_integer(current_user_id) end)
      else
        all_users  # If no current user, show all users
      end

    {:ok, assign(socket, users: users)}  # Assign the filtered users to the socket
  end

  def render(assigns) do
    ~H"""
    <div class="matches-content">
      <h1>Matches</h1>  <!-- Changed to h1 for larger heading -->

      <%= if @users && @users != [] do %>
        <ul class="matches-list">
          <%= for user <- @users do %>
            <li>
              <a href={~p"/@#{user.username}"} class="match-card"> <!-- Make the whole card clickable -->
                <h3>@<%= user.username %></h3>
              </a>
            </li>
          <% end %>
        </ul>
      <% else %>
        <p class="no-matches">No matches available at the moment.</p>  <!-- Updated message for no matches -->
      <% end %>

      <style>
        .matches-content {
          padding: 20px;
          background-color: #1D2125; /* Same as header/footer */
          border-radius: 8px;
          margin: 20px;
        }

        h1 {
          font-size: 2.5em;  /* Adjust font size for heading */
          color: white;      /* White color for visibility */
          margin-bottom: 20px; /* Space below the heading */
        }

        .matches-list {
          list-style-type: none;
          padding: 0;
        }

        .match-card {
          display: block; /* Make the anchor act like a block element */
          background-color: #282C30; /* Darker card background */
          border: 1px solid #ff6b81; /* Border color */
          border-radius: 5px;
          padding: 15px;
          margin: 10px 0;
          transition: background-color 0.3s ease;
          text-decoration: none; /* Remove underline from the link */
          color: white; /* Set text color for the card */
        }

        .match-card:hover {
          background-color: #3A3E42; /* Highlight on hover */
        }

        .no-matches {
          color: #A0A0A0; /* Lighter color for no matches message */
        }

      </style>
    </div>
    """
  end
end
