defmodule BadDateWeb.UserProfileHTML do
  use BadDateWeb, :html
  import :crypto

  # Define the render function for the "show.html" template
  def render("show.html", assigns) do
    ~H"""
    <div id="profile" class="mx-auto max-w-sm">
    <br /><br />
    <img id='gravatarpfp'/>
    <br />
    <h1 id="username">@<%= @user.username %></h1>

    </div>
    <style>
      img{
        border-radius : 100px;
        text-align: center;
        margin: auto;
        display: block;
      }
      #username{
        text-align: center;
        font-weight: 800;
        font-size: 50px;
      }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
    <script>
        const pfpElement = document.getElementById("gravatarpfp");
        pfpElement.src = getGravatarUrl('<%= @user.email %>');

        console.log(getGravatarUrl('reecexavier@gmail.com'));
        // Function to generate the Gravatar URL from email
        function getGravatarUrl(email, size = 200) {
            // 1. Trim and convert email to lowercase
            const cleanEmail = email.trim().toLowerCase();

            // 2. Create MD5 hash of the email
            const hash = CryptoJS.MD5(cleanEmail).toString();

            // 3. Return Gravatar URL with the hash
            return `https://www.gravatar.com/avatar/${hash}?s=${size}&d=identicon`;
        }

        // Example usage
        function loadGravatar() {
            const email = document.getElementById('email').value;
            const gravatarUrl = getGravatarUrl(email);

            // Set the Gravatar image source
            document.getElementById('gravatarImage').src = gravatarUrl;
        }
    </script>

    """
  end

  # If you want to define a show function, it might just render the show template
  def show(assigns) do
    render("show.html", assigns)
  end

  # Helper function to generate the Gravatar URL based on email
  defp gravatar_url(email) do
    email
    |> String.downcase()    # Gravatar expects a lowercase email
    |> :crypto.hash(:md5)    # Hash the email using MD5
    |> Base.encode16(case: :lower) # Encode the hash to a lowercase hexadecimal string
    |> gravatar_url_for_hash()
  end

  defp gravatar_url_for_hash(hash) do
    "https://www.gravatar.com/avatar/#{hash}?s=200&d=identicon"  # 200px size, identicon fallback
  end
end
