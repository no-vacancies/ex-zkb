defmodule ExZkb.Discord.Embed do
  defstruct [
    :title,
    :type,
    :description,
    :url,
    :timestamp,
    :color,
    :footer,
    :image,
    :thumbnail,
    :video,
    :provider,
    :author,
    :fields
  ]

  defmodule Footer do
    defstruct [
      :text,
      :icon_url,
      :proxy_icon_url
    ]
  end

  defmodule Media do
    @moduledoc """
    Used for Image, Thumbnail and Video. `:proxy_url` is not valid for Video embeds.
    """
    defstruct [
      :url,
      :proxy_url,
      :height,
      :width
    ]
  end

  defmodule Provider do
    defstruct [
      :name,
      :url
    ]
  end

  defmodule Author do
    defstruct [
      :name,
      :url,
      :icon_url,
      :proxy_icon_url
    ]
  end

  defmodule Field do
    defstruct [
      :name,
      :value,
      :inline
    ]
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed.Footer do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed.Media do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed.Provider do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed.Author do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end

defimpl Jason.Encoder, for: ExZkb.Discord.Embed.Field do
  def encode(value, opts) do
    value
    |> ExZkb.Util.prune()
    |> Jason.Encode.map(opts)
  end
end
