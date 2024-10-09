defmodule BadDateWeb.UserProfileHTML do
  use BadDateWeb, :html

  # Define the render function for the "show.html" template
  def render("show.html", assigns) do
    # You can customize the rendering process if needed,
    # or simply use the default behavior.
    ~H"""

    <h1>User Profile</h1>
    <p>This is the profile for <%= @user.username %>.</p>
    """
  end

  # If you want to define a show function, it might just render the show template
  def show(assigns) do
    render("show.html", assigns)
  end
end
