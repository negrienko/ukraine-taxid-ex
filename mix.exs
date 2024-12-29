defmodule UkraineTaxidEx.MixProject do
  use Mix.Project

  @app :ukraine_tax_id
  @module UkraineTaxidEx
  @source_url "https://g.tulz.dev/opensource/ukraine-taxid-ex"
  @docs_url "https://hexdocs.pm/#{@app}"
  @version "0.1.3"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    """
    Library to parse and validate EDRPOU (unique 8-digit number that identifies legal entities in Ukraine registered in the official business register) and ITIN (unique identification number assigned to individuals for tax purposes)
    """
  end

  defp dialyzer() do
    [
      plt_add_apps: [@app]
    ]
  end

  defp package() do
    [
      maintainers: ["Danylo Negrienko"],
      licenses: ["Apache-2.0"],
      links: %{"Git Repository" => @source_url, "Author's Blog" => "https://negrienko.com"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "#{@module}",
      source_ref: "v#{@version}",
      canonical: @docs_url,
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Checks
      {:lettuce, "~> 0.3.0", only: :dev},
      {:ex_check, "~> 0.14.0", only: ~w(dev test)a, runtime: false},
      {:credo, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:dialyxir, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:doctor, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:ex_doc, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:sobelow, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:mix_audit, ">= 0.0.0", only: ~w(dev test)a, runtime: false},
      {:observer_cli, "~> 1.7.4", only: :dev, runtime: false},
      {:elixir_sense, github: "elixir-lsp/elixir_sense", only: ~w(dev)a}
    ]
  end
end
