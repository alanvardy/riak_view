defmodule RiakView.Scene.Key do
  use Scenic.Scene
  require Logger

  alias Scenic.{Graph, ViewPort}

  import Scenic.Primitives
  import Scenic.Components

  @title "Key "
  @title_size RiakView.Scene.Config.title_size()
  @text_size RiakView.Scene.Config.text_size()
  @top_spacing RiakView.Scene.Config.top_spacing()
  @width RiakView.Scene.Config.width()

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(%{bucket: bucket, key: key}, opts) do
    {:ok,
     %{
       value: value,
       updated: updated,
       etag: etag
     }} = RiakView.Riak.get_key(bucket, key)

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      |> add_specs_to_graph([
        button_spec("< Back", id: :back, theme: :secondary, translate: {20, @top_spacing / 2}),
        text_spec(@title <> key,
          translate: {@width / 2, @top_spacing},
          id: :title,
          text_align: :center,
          font_size: @title_size
        ),
        text_spec(inspect(value), translate: {50, 150}, font_size: @text_size * 1.3),
        text_spec("Updated: #{updated}", translate: {50, 200}),
        text_spec("eTag: #{etag}", translate: {50, 225})
      ])

    {:ok, %{graph: graph, bucket: bucket, viewport: opts[:viewport]}, push: graph}
  end

  def filter_event({:click, :back}, _context, %{viewport: viewport, bucket: bucket} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.Bucket, bucket})
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
