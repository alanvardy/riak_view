defmodule RiakView.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.{Graph, ViewPort}

  import Scenic.Primitives
  import Scenic.Components

  @title "Riak Client"
  @title_size RiakView.Scene.Config.title_size()
  @top_spacing RiakView.Scene.Config.top_spacing()
  @width RiakView.Scene.Config.width()

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input

    graph =
      Graph.build(font: :roboto, font_size: @title_size)
      |> add_specs_to_graph([
        text_spec(@title,
          translate: {@width / 2, @top_spacing},
          id: :title,
          text_align: :center
        ),
        button_spec("Local Buckets", id: :local_buckets, translate: {@width / 2 - 70, 200})
      ])

    {:ok, %{graph: graph, viewport: opts[:viewport]}, push: graph}
  end

  def handle_input({:codepoint, {letter, _}}, _context, %{graph: graph}) do
    graph = Graph.modify(graph, :text, &text(&1, "You pushed: #{letter}"))

    {:noreply, %{graph: graph}, push: graph}
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  def filter_event({:click, :local_buckets}, _context, %{viewport: viewport} = state) do
    ViewPort.set_root(viewport, {RiakView.Scene.LocalBuckets, nil})
    {:halt, state}
  end

  def filter_event(event, _context, state) do
    Logger.info("Filtered event: #{inspect(event)}")
    {:noreply, state}
  end
end
