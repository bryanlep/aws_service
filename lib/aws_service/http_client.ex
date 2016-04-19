defmodule AWSService.HTTPClient do

  ## Types

  @type http_method_t :: :get |
                         :post |
                         :put |
                         :delete |
                         :head |
                         :options

  @type response_t :: {:ok | :error, any}


  ## AWSServiceClient.HTTPClient definition

  @doc """
  Performs an HTTP request.
  """
  @callback request(method  :: http_method_t,
                    url     :: binary,
                    headers :: Keyword.t,
                    data    :: iodata | nil)
                    :: response_t


  ## `use` implementation

  @doc false
  defmacro __using__(_) do
    quote do
      @behaviour AWSService.HTTPClient
    end
  end

end
