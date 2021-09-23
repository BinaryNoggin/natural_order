defmodule MrNatural.MixProject do
  use Mix.Project
  @version "0.1.0"
  @github_link "https://github.com/binarynoggin/mr_natural"

  def project do
    [
      app: :mr_natural,
      version: @version,
      elixir: "~> 1.10",
      description: "A utility to compare strings in Natural order.",
      source_url: @github_link,
      homepage_url: @github_link,
      package: package(),
      docs: docs(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:propcheck, "~> 1.4", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      links: %{
        "GitHub" => @github_link,
        "Binary Noggin" => "https://binarynoggin.com"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end
end
