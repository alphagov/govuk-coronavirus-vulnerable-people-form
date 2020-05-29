class UploadErrorPages
  def initialize(error_pages: [], s3_client:, bucket_name:)
    @error_pages = error_pages
    @s3_client = s3_client
    @bucket_name = bucket_name
  end

  def upload
    error_pages.map do |error_page|
      path = Rails.root.join("public", error_page)
      s3_client.put_object(
        acl: "public-read",
        body: File.open(path).read,
        bucket: bucket_name,
        key: "errors/#{error_page}",
      )
    end
  end

private

  attr_reader :error_pages, :s3_client, :bucket_name
end
