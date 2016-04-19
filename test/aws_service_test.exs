defmodule AWSServiceTest do
  use ExUnit.Case
  doctest AWSService

  alias AWSService.Test.TestService


  test "get request" do
    {:ok, stuff} = TestService.get("http://bucket.s3.amazonaws.com/file.txt")
IO.puts "stuff; #{inspect stuff}"
  end

  test "put request" do
  end

end
