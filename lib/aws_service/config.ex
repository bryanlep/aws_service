defmodule AWSService.Config do
  @moduledoc """
  Utilities for handling configuration options.
  """

  @app_key :aws_service

  
  ## `use` implementation

  @doc false
  defmacro __using__(:global),
    do: apply(__MODULE__, :global, [])
  defmacro __using__(service),
    do: apply(__MODULE__, :service!, [service])


  @doc """
  Parses global AWSService configuration options and sets
  them to module attribute @global_config.
  """
  @spec global :: none
  def global do
    config = Application.get_all_env(@app_key)
    {_, global_config} = extract_required_option!({config, []}, :http_client)
    quote do
      @global_config unquote(global_config)
    end
  end

  @dec """
  Parses AWSService configuration options for a specific service.
  An exception is raised when required attributes are missing.

  Service credentials are validated and set in the module attribute
  @service_credentials. They are required and are as follows:

    access_key  : public access key used to access the service
    secret_key  : private access key used to sign AWS requests
    service     : name of the service
    region      : AWS region the service is in

  All additional configuration options are set in the module attribute
  @service_options.
  """
  @spec service!(atom) :: none
  def service!(service) do
    config = Application.get_env(@app_key, service, %{})
    {opts, creds} = 
      extract_required_option!({config, []}, :access_key, service)
      |> extract_required_option!(:secret_key, service)
      |> extract_required_option!(:service, service)
      |> extract_required_option!(:region, service)

    quote do
      @service_credentials unquote(creds)
      @service_options unquote(opts)
    end
  end
  
  
  ## Helper functions

  #
  # Removes the given option from `from_config` and places it
  # in `to_config`.
  #
  # An exception is raised if the option is not found.
  #
  @doc false
  @spec extract_required_option!({Keyword.t, Keyword.t}, atom, atom) :: {Keyword.t, Keyword.t}
  defp extract_required_option!({from_config, to_config}, option, config_type \\ nil) do
    case Keyword.pop(from_config, option) do
      {nil, _}        ->
        type = if is_nil(config_type), do: "global", else: ":#{config_type}"
        raise ArgumentError, "Missing #{type} configuration option `#{option}`"
      {value, config} -> {config, Keyword.put(to_config, option, value)}
    end
  end

end
