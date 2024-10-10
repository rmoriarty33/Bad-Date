defmodule BadDateWeb.MatchesLive do
  use BadDateWeb, :live_view
  alias BadDate.Repo
  alias BadDate.Accounts.User

  def mount(_params, session, socket) do
    current_user_id = session["user_id"]
    IO.inspect(current_user_id, label: "Current User ID")

    all_users = Repo.all(User)

    users =
      if current_user_id do
        all_users
        |> Enum.reject(fn user -> user.id == String.to_integer(current_user_id) end)
      else
        all_users
      end

    {:ok, assign(socket, users: users, load_count: 4)}  # Initial load count set to 4
  end

  def render(assigns) do
    ~H"""
    <div class="matches-content">
      <h2>Available Users</h2>

      <%= if @users && @users != [] do %>
        <ul class="matches-list">
          <%= for user <- Enum.take(@users, @load_count) do %>  <!-- Limit number of displayed users -->
            <li class="match-item">
              <div class="match-card">
                <div class="profile-container"> <!-- New container for profile picture -->
                  <img src="/images/temp_profile.png" alt="Temporary profile picture" class="profile-picture" /> <!-- Temporary profile picture -->
                </div>
                <h3 class="username">@<%= user.username %></h3> <!-- Username below the picture -->

                <div class="button-group"> <!-- Button group for buttons -->
                  <button class="message-button">Message</button> <!-- Placeholder button -->
                  <button phx-click="view_profile" phx-value-username={user.username} class="view-profile-button">View Profile</button> <!-- New button to view profile -->
                </div>

              </div>
            </li>
          <% end %>
        </ul>

        <div class="load-more-container"> <!-- New container to center the button -->
          <button phx-click="load_more" class="load-more-button">Load More</button> <!-- Load more button -->
        </div>
      <% else %>
        <p class="no-matches">No users available at the moment.</p>
      <% end %>

      <style>
        .matches-content {
          padding: 20px;
          background-color: #1D2125;
          border-radius: 8px;
          margin: 20px;
          min-height: 100vh; /* Ensure it takes full height of the viewport */
          display: flex;
          flex-direction: column;
          justify-content: flex-start; /* Align items to the top */
        }

        h2 {
          font-size: 2.5em; /* Increased font size for header */
          color: white;
          margin-bottom: 20px;
        }

        .matches-list {
          list-style-type: none;
          padding: 0;
          display: flex;
          flex-wrap: wrap; /* Allow wrapping of match cards */
        }

        .match-item {
          flex: 1 0 21%; /* Adjusted to take 4 per row */
          margin: 10px; /* Space between items */
        }

        .match-card {
          background-color: #282C30;
          border: 1px solid #ff6b81;
          border-radius: 5px;
          padding: 20px; /* Increased padding for larger cards */
          transition: background-color 0.3s ease;
          text-align: center; /* Center content in the card */
          height: 450px; /* Set a fixed height for consistency and taller cards */
          display: flex; /* Enable flexbox layout */
          flex-direction: column; /* Arrange items vertically */
          justify-content: flex-start; /* Align items to the top */
        }

        .match-card:hover {
          background-color: #3A3E42;
        }

        .profile-container {
          margin-bottom: 15px; /* Space between profile and buttons */
        }

        .profile-picture {
          width: 200px; /* Increased width for the profile picture */
          height: 200px; /* Increased height for the profile picture */
          border-radius: 50%; /* Circular profile picture */
          display: block; /* Center the image */
          margin-left: auto; /* Center the image */
          margin-right: auto; /* Center the image */
          border: 4px solid #ff6b81; /* Added border around the profile picture */
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); /* Optional shadow for a 3D effect */
        }

        .username {
          color: white; /* Text color for visibility */
          font-size: 1.5em; /* Increased font size for username */
          margin-bottom: 10px; /* Space below the username */
        }

        .button-group {
          display: flex; /* Align buttons in a row */
          justify-content: space-between; /* Space buttons evenly */
          margin-top: 10px; /* Space above the button group */
        }

        .message-button,
        .view-profile-button {
          background-color: #ff6b81;
          color: white;
          border: none;
          border-radius: 5px;
          padding: 10px 15px; /* Increased padding for the buttons */
          cursor: pointer;
          transition: background-color 0.3s ease;
          font-size: 1em; /* Increased font size for the buttons */
          flex: 1; /* Allow buttons to share space evenly */
          margin: 0 5px; /* Space between buttons */
        }

        .message-button:hover,
        .view-profile-button:hover {
          background-color: #ff4c61; /* Darker on hover */
        }

        .load-more-container {
          display: flex;
          justify-content: center; /* Center the Load More button */
          margin-top: 20px; /* Space above the Load More button */
        }

        .load-more-button {
          padding: 10px 20px; /* Increased padding for the button */
          background-color: #ff6b81;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
          transition: background-color 0.3s ease;
          font-size: 1em; /* Slightly larger font size for the Load More button */
        }

        .load-more-button:hover {
          background-color: #ff4c61; /* Darker on hover */
        }

        .no-matches {
          color: #A0A0A0;
          font-size: 1.2em; /* Increased font size for no matches message */
        }
      </style>
    </div>
    """
  end

  def handle_event("load_more", _params, socket) do
    new_load_count = socket.assigns.load_count + 4  # Increment load count by 4
    {:noreply, assign(socket, load_count: new_load_count)}  # Update load count
  end

  def handle_event("view_profile", %{"username" => username}, socket) do
    # Redirect to the user's profile page using the @username format
    socket = push_redirect(socket, to: "/@#{username}")
    {:noreply, socket}  # Ensure to return a valid response
  end
end
