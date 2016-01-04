defmodule Challenges.Mixfile do
  use Mix.Project

  def project do
    [app: :challenges,
     version: "0.1.0",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]

  defp deps do
    [{:remix, "~> 0.0.1", only: :dev}]
  end
end
