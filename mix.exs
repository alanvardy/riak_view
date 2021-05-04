defmodule RiakView.MixProject do
  use Mix.Project

  def project do
    [
      app: :riak_view,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {RiakView, []},
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.10"},
      {:scenic_driver_glfw, "~> 0.10", targets: :host},
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.10"},
      {:jason, "~> 1.2"}
    ]
  end
end
