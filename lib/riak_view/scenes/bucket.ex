defmodule RiakView.Scene.Bucket do
  use Scenic.Scene
  require Logger

  alias Scenic.{Graph, ViewPort}

  import Scenic.Primitives
  import Scenic.Components

  @title "Bucket "
  @title_size RiakView.Scene.Config.title_size()
  @text_size RiakView.Scene.Config.text_size()
  @top_spacing RiakView.Scene.Config.top_spacing()
  @width RiakView.Scene.Config.width()

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(bucket, opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input

    key_buttons =
      RiakView.Riak.all_keys(bucket)
      |> Enum.with_index()
      |> Enum.map(fn {name, index} ->
        button_spec(name,
          id: {:key, name},
          translate: {20, @top_spacing * 2 + index * @top_spacing}
        )
      end)

    properties =
      bucket
      |> RiakView.Riak.get_bucket_properties()
      |> Enum.with_index()
      |> Enum.map(fn {{key, value}, index} ->
        text_spec("#{key}: #{inspect(value)}",
          translate: {@width / 3, @top_spacing * 2 + index * @top_spacing / 2},
          font_size: @text_size
        )
      end)

    graph =
      Graph.build(font: :roboto)
      |> add_specs_to_graph(
        [
          button_spec("< Back", id: :back, theme: :secondary, translate: {20, @top_spacing / 2}),
          text_spec(@title <> bucket,
            translate: {@width / 2, @top_spacing},
            id: :text,
            text_align: :center,
            font_size: @title_size
          )
          | key_buttons
        ] ++ properties
      )

    {:ok, %{graph: graph, viewport: opts[:viewport], bucket: bucket}, push: graph}
  end

  def filter_event({:click, :back}, _context, %{viewport: viewport} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.LocalBuckets, nil})
    {:halt, state}
  end

  def filter_event({:click, {:key, key}}, _context, %{viewport: viewport, bucket: bucket} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.Key, %{bucket: bucket, key: key}})
    {:halt, state}
  end

  def filter_event(event, _context, state) do
    Logger.info("Filtered event: #{inspect(event)}")
    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end
end
