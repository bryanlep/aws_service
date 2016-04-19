defmodule AWSService.Test.HTTPClient do
  @moduledoc """
  HTTP client used for a test AWService.
  """
  
  use AWSService.HTTPClient


  ## AWSServiceClient.HTTPClient implementation

  def request(metohd, url, headers, data \\ nil)
  def request(method, url, headers, data) do
    {:ok, {method, url, headers, data}}
  end

end
