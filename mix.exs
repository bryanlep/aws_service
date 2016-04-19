defmodule AWSService.Mixfile do
  use Mix.Project

  def project do
    [app: :aws_service,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  
  ## Helper functions

  # Specifies which paths to compile for an environment
  defp elixirc_paths(:test), do: ["lib", "test/lib"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:aws_auth, path: "/home/bryan/source/apps/elixir_utilities/aws_auth"}]
  end

end
