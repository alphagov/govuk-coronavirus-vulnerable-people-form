Aws.config.update({
  region: 'eu-west-1',
  credentials: Aws::Credentials.new(
    'fakeMyKeyId',
    'fakeSecretAccessKey'
  )
})
