defmodule BadDateWeb.ErrorHelpers do
 # import Phoenix.HTML
 # import Phoenix.HTML.Form
  use PhoenixHTMLHelpers

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # If the error message is a translation key, we use the given options to
    # translate it.
    if count = opts[:count] do
      Gettext.dngettext(BadDateWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(BadDateWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error), class: "help-block")
    end)
  end
end
