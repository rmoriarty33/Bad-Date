defmodule BadDateWeb.UserProfileController do
  use BadDateWeb, :controller
  alias BadDate.Accounts  # Ensure this is the correct alias

  def show(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)

    # Set the view and render the user profile show template
    conn
    |> put_view(BadDateWeb.UserProfileHTML)  # Set the view
    |> render("show.html", user: user)  # Render with view and template
  end
end
