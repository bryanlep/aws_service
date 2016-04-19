## Configuration for the test environment
use Mix.Config

# Global AWSService configuration
config :aws_service,
  http_client: AWSService.Test.HTTPClient

# Test service client configuration
config :aws_service, :test_config,
  access_key: "AKIAIOSFODNN7EXAMPLE",
  secret_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
  service: "s3",
  region: "us-east-1",
  bucket: "somebucket"
