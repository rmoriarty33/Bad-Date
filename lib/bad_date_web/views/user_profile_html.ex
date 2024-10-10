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
    <h2>Interests</h2>
    <ul id="interests">displayInterests(interests)</ul>
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
        const interestsElement = document.getElementById("interests");
        const email = '<%= @user.email %>';
        //profile pic
        pfpElement.src = getGravatarUrl('<%= @user.email %>');
        
        //fetch gravatar user profile to get interests
        fetchGravatarProfile(email);

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
        async function fetchGravatarProfile(email) {
    const response = await fetch(`/api/gravatar?email=${encodeURIComponent(email)}`);
    if (!response.ok) {
        throw new Error('Network response was not ok');
    }

    const data = await response.json();
    const interests = data.entry[0]?.interests || []; // Adjust based on the actual API response structure
    displayInterests(interests);
}


        async function fetchGravatarProfile(email) {
        const hash = CryptoJS.MD5(email.trim().toLowerCase()).toString();
        const url = `https://www.gravatar.com/${hash}.json`;

        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error('Network response was not ok');

            const data = await response.json();
            const interests = data.entry[0]?.interests || []; // Adjust based on the actual API response structure
            displayInterests(interests);
        } catch (error) {
            console.error('Error fetching Gravatar profile:', error);
            interestsElement.innerHTML = 'Failed to load interests.';
        }
    }

    function displayInterests(interests) {
        if (interests.length > 0) {
            interestsElement.innerHTML = interests.map(interest => `<li>${interest}</li>`).join('');
        } else {
            interestsElement.innerHTML = '<li>No interests found.</li>';
        }
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
