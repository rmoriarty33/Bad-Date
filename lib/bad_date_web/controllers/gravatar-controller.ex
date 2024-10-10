 defmodule BadDateWeb.GravatarController do
  use BadDateWeb, :controller
  import :crypto

  def fetch_profile(conn, %{"email" => email}) do
    email_hash = email |> String.trim() |> String.downcase() |> hash_email()
    url = "https://www.gravatar.com/#{email_hash}.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, body)

      {:ok, %HTTPoison.Response{status_code: code}} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(code, "Error fetching profile")

      {:error, reason} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{error: reason}))
    end
  end

  defp hash_email(email) do
    email
    |> :crypto.hash(:md5)
    |> Base.encode16(case: :lower)
  end
end