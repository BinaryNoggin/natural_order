defmodule NaturalOrder.MixProject do
  use Mix.Project
  @version "0.2.0"
  @github_link "https://github.com/binarynoggin/natural_order"

  def project do
    [
      app: :natural_order,
      version: @version,
      elixir: "~> 1.10",
      description: "A utility to compare strings in Natural order.",
      source_url: @github_link,
      homepage_url: @github_link,
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:propcheck, "~> 1.4", only: [:dev, :test]},
      {:ex_doc, "~> 0.25.3", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Binary Noggin", "Amos King"],
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
