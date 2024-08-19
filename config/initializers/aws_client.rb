# # frozen_string_literal: true

if Rails.env.production?
  Aws.config.update(
    endpoint: 'https://' + ENV["STACKHERO_MINIO_HOST"],
    access_key_id: ENV["STACKHERO_MINIO_ROOT_ACCESS_KEY"],
    secret_access_key: ENV["STACKHERO_MINIO_ROOT_SECRET_KEY"],
    force_path_style: true,
    region: 'us-east-1'
  )
end