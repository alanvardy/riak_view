defmodule RiakView.Scene.LocalBuckets do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives
  import Scenic.Components

  @title "Local Buckets"
  @title_size RiakView.Scene.Config.title_size()
  @top_spacing RiakView.Scene.Config.top_spacing()
  @width RiakView.Scene.Config.width()

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input

    bucket_buttons =
      RiakView.Riak.all_buckets()
      |> Enum.with_index()
      |> Enum.map(fn {name, index} ->
        button_spec(name, id: {:bucket, name}, translate: {20, @top_spacing * 2 + index * 50})
      end)

    graph =
      Graph.build(font: :roboto, font_size: @title_size)
      |> add_specs_to_graph([
        button_spec("< Back", id: :back, theme: :secondary, translate: {20, @top_spacing / 2}),
        text_spec(@title,
          translate: {@width / 2, @top_spacing},
          id: :text,
          text_align: :center
        )
        | bucket_buttons
      ])

    {:ok, %{graph: graph, viewport: opts[:viewport]}, push: graph}
  end

  def filter_event({:click, {:bucket, name}}, _context, %{viewport: viewport} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.Bucket, name})
    {:halt, state}
  end

  def filter_event({:click, :back}, _context, %{viewport: viewport} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.Home, nil})
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
