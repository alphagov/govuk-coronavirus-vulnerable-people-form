RSpec.describe UploadErrorPages do
  describe "#upload" do
    it "uploads error pages to S3" do
      client = Aws::S3::Client.new(
        region: "eu-west-2",
        access_key_id: "my-key-id",
        secret_access_key: "my-secret-access-key",
        stub_responses: true,
      )

      bucket = { "my-lovely-bucket-name" => { body: "<h1>Error!</h1>" } }

      client.stub_responses(
        :put_object,
        lambda { |context|
          bucket[context.params[:key]] = { body: context.params[:body] }
          {}
        },
      )

      responses = UploadErrorPages.new(
        error_pages: %w[404.html 500.html],
        s3_client: client,
        bucket_name: "my-lovely-bucket-name",
      ).upload

      expect(responses).to all(be_an(Seahorse::Client::Response))
    end
  end
end
