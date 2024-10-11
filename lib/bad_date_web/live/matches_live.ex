defmodule BadDateWeb.MatchesLive do
  use BadDateWeb, :live_view
  alias BadDate.Repo
  alias BadDate.Accounts.User

  @interests_list [
    "Photography", "Traveling", "Cooking", "Hiking", "Reading", "Music", "Gaming", "Cycling",
          "Running", "Swimming", "Writing", "Painting", "Drawing", "Singing", "Dancing",
          "Knitting", "Coding", "Blogging", "Yoga", "Meditation", "Martial Arts", "Fitness",
          "Weightlifting", "Surfing", "Fishing", "Skiing", "Snowboarding", "Camping", "Gardening",
          "Bird Watching", "Astronomy", "Baking", "Woodworking", "Leathercraft", "Jewelry Making",
          "Pottery", "Calligraphy", "Graphic Design", "Interior Design", "Fashion", "Photography",
          "Film Making", "Podcasting", "Public Speaking", "Magic Tricks", "Astrology", "Karaoke",
          "Volunteering", "Chess", "Board Games", "Puzzles", "Card Games", "Video Editing",
          "Beatboxing", "Songwriting", "Stand-up Comedy", "Storytelling", "Historical Research",
          "Genealogy", "Language Learning", "Debating", "Political Activism", "Animal Care",
          "Dog Training", "Robotics", "Electronics", "DIY Projects", "Home Improvement",
          "Makeup Artistry", "Nail Art", "Hairstyling", "Perfume Making", "Wine Tasting",
          "Beer Brewing", "Coffee Brewing", "Mixology", "Bartending", "Cryptocurrency Trading",
          "Stock Trading", "Real Estate Investing", "Sailing", "Scuba Diving", "Snorkeling",
          "Rock Climbing", "Skydiving", "Bungee Jumping", "Archery", "Hunting", "Airsoft",
          "Paintball", "Golf", "Tennis", "Badminton", "Table Tennis", "Soccer", "Basketball",
          "Baseball", "Football", "Rugby", "Cricket", "Lacrosse", "Skateboarding", "Rollerblading",
          "Parkour", "Frisbee", "Ultimate Frisbee"
    # Add more interests as needed
  ]

  def mount(_params, session, socket) do
    current_user_id = Map.get(session, "user_id")

    all_users = Repo.all(User)

    users =
      if current_user_id do
        all_users
        |> Enum.reject(fn user -> user.id == String.to_integer(current_user_id) end)
      else
        all_users
      end

    users_with_interests = Enum.map(users, fn user ->
      interests = get_random_interests(:rand.uniform(5)) # Get 3 random interests
      Map.put(user, :interests, interests) # Add interests to the user struct
    end)

    {:ok, assign(socket, users: users_with_interests, load_count: 4)}
  end

  defp get_random_interests(count) do
    @interests_list
    |> Enum.shuffle() # Shuffle the interests list
    |> Enum.take(count) # Take the specified count
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
                <img src="https://www.gravatar.com/avatar/00000000000000000000000000000000" alt="Temporary profile picture" class="profile-picture" />
                </div>
                <h4>Tags</h4>
                  <h3 class="username">@<%= user.username %></h3> <!-- Username below the picture -->
                    <h4>Tags</h4>
                    <div class="interests"></div>
                    <div class="interests">
                  <%= for interest <- user.interests do %> <!-- Use interests from the user struct -->
                    <div class="interest"><%= interest %></div>
                  <% end %>
                </div>
                    <div class="button-group"> <!-- Button group for buttons -->
                    <button phx-click="send_message" phx-value-email="{user.email}" class="message-button"><%= user.email %></button>
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
      .interests {
        display: flex; /* Add this line */
        flex-wrap: wrap; /* Allows the buttons to wrap */
        justify-content: center; /* Centers the buttons */
        max-width: 80%; /* Restrict the container width */
        margin: 0 auto; /* Center the container itself */
      }

      .interest {
        background-color: #ff6b81;
        color: white;
        border: none;
        border-radius: 5px;
        padding: 5px 10px; /* Adjusted padding for the buttons */
        cursor: pointer;
        transition: background-color 0.3s ease;
        font-size: 1em; /* Increased font size for the buttons */
        max-width: 150px; /* Limit the button width */
        width: auto; /* Allow buttons to size naturally */
        text-align: center; /* Center the button text */
        margin: 0 5px;

      }

      .interest:hover { /* Corrected class name */
        background-color: #ff4c61; /* Darker on hover */
      }

      .match-card {
        background-color: #282C30;
        border: 1px solid #ff6b81;
        border-radius: 5px;
        padding: 20px; /* Increased padding for larger cards */
        transition: background-color 0.3s ease;
        text-align: center; /* Center content in the card */
        /* Remove fixed height to allow for dynamic content */
        display: flex; /* Enable flexbox layout */
        flex-direction: column; /* Arrange items vertically */
        justify-content: flex-start; /* Align items to the top */
      }


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
