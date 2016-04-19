defmodule AWSService do
  @moduledoc """
  Defines an AWS service client that has credential information baked
  in, removing the need to pass in credentials when issuing a request.
  """


  ## `use` implementation
 
  defmacro __using__(service_config) do
    quote do
      alias AWSAuth.Credentials
      import AWSService.Client

      use AWSService.Config, unquote(service_config)
      @access_key   Keyword.fetch!(@service_credentials, :access_key)
      @secret_key   Keyword.fetch!(@service_credentials, :secret_key)
      @service      Keyword.fetch!(@service_credentials, :service)
      @region       Keyword.fetch!(@service_credentials, :region)


      ## Default implementation

      def get(url, headers \\ []), do: get(url, headers, credentials)
      def put(url, headers, data), do: put(url, headers, credentials)

      #
      # Builds the credentials for the service.
      #
      @spec credentials :: Credentials.t
      defp credentials do
        %Credentials{access_key:  @access_key,
                     secret_key:  @secret_key,
                     datetime:    :calendar.universal_time,
                     service:     @service,
                     region:      @region}
      end

    end
  end

end
