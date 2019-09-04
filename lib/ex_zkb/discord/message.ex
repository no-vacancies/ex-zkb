defmodule ExZkb.Discord.Message do
  defstruct [
    :content,
    :username,
    :avatar_url,
    :tts,
    :file,
    :embeds
  ]

  def text(content, opts \\ []) do
    opts = Keyword.merge(opts, content: content)
    struct(__MODULE__, opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Message do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end
