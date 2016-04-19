defmodule AWSService.Client do
  @moduledoc """
  """

  alias AWSAuth.Credentials
  alias AWSAuth.CanonicalRequest
  alias AWSService.HTTPClient

  import AWSAuth.Encoding.Date, only: [encode_iso8601: 1]

  use AWSService.Config, :global
  @http_client Keyword.get(@global_config, :http_client)


  @doc """
  """
  @spec get(binary, Keyword.t, Credentials.t) :: HTTPClient.response_t
  def get(url, headers, credentials = %Credentials{}) do
    headers = prepare_aws_headers(headers, "GET", url, "", credentials, payload: false)
    send_http_request(:get, url, headers, nil)
  end

  @doc """
  """
  @spec put(binary, Keyword.t, iodata, Credentials.t) :: HTTPClient.response_t
  def put(url, headers, data, credentials = %Credentials{}) do
    headers = prepare_aws_headers(headers, "PUT", url, data, credentials)
    send_http_request(:put, url, headers, data)
  end


  ## Helper functions

  #
  # Sends an HTTP request to the url with the given method, headers, and data.
  # 
  @spec send_http_request(HTTPClient.http_method_t, binary, Keyword.t, iodata) :: HTTPClient.response_t
  defp send_http_request(method, url, headers, data) do
    case @http_client.request(method, url, headers, data) do
      {:error, reason} -> {:error, reason}
      response         -> response
    end
  end

  #
  # Prepares the headers needed to make a request to an AWS service.
  #
  # Available options:
  #   payload       : boolean, true; whether to include payload headers.
  #   authorization : boolean, true; whether to include the Authorization header. 
  #
  @spec prepare_aws_headers(Keyword.t, binary, binary, iodata, Credentials.t, Keyword.t) :: Keyword.t
  defp prepare_aws_headers(headers, method, url, data, credentials, opts \\ []) do
    uri = URI.parse(url)

    headers = Keyword.put(headers, :host, uri.host)
      |> Keyword.put(:"x-amz-date", encode_iso8601(credentials.datetime))

    # optionally add hashed payload header
    if !Keyword.get(opts, :payload, true) do
      headers = Keyword.put(headers, :"x-amz-content-sha256", CanonicalRequest.encode_payload(data))
    end

    # build AWS request and sign it
    request = CanonicalRequest.build(method, url, headers, data)
    signature = request_signature(request, credentials)

    # optionally add the Authorization header
    if Keyword.get(opts, :authorization, true) do
      authorization_header = AWSAuth.authorization_header(request, credentials, signature)
      headers = Keyword.put(headers, :authorization, authorization_header)
    end

    headers
  end

  #
  # Calculates the request signature using the credentials.
  #
  @spec request_signature(CanonicalRequest.t, Credentials.t) :: binary
  defp request_signature(request = %CanonicalRequest{}, credentials = %Credentials{}) do
    string_to_sign = AWSAuth.string_to_sign(request, credentials)
    signing_key = AWSAuth.signing_key(credentials)
    AWSAuth.signature(string_to_sign, signing_key)
  end

end
