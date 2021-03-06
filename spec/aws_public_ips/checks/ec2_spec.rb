# frozen_string_literal: true

describe ::AwsPublicIps::Checks::Ec2 do
  it 'should return ec2 ips' do
    stub_request(:post, 'https://ec2.us-east-1.amazonaws.com')
      .to_return(body: ::IO.read('spec/fixtures/ec2.xml'))

    expect(subject.run(true)).to eq([
      {
        id: 'i-0f22d0af796b3cf3a',
        hostname: 'ec2-54-234-208-236.compute-1.amazonaws.com',
        ip_addresses: %w[54.234.208.236]
      },
      {
        id: 'i-04ef469b441883eda',
        hostname: 'ec2-18-206-76-65.compute-1.amazonaws.com',
        ip_addresses: %w[18.206.76.65 2600:1f18:63e0:b400:f50c:59a7:a182:3717]
      },
      {
        id: 'i-03a7b3bc2b4c20742',
        hostname: nil,
        ip_addresses: %w[2600:1f18:60f3:eb00:1c6e:5184:8955:170c]
      },
      {
        id: 'i-01e4cbbe2c7fb98f6',
        hostname: 'ec2-50-112-85-68.us-west-2.compute.amazonaws.com',
        ip_addresses: %w[50.112.85.68 54.214.97.117]
      }
    ])
  end

  it 'should not return an entry when there are no public ips' do
    stub_request(:post, 'https://ec2.us-east-1.amazonaws.com')
      .to_return(body: ::IO.read('spec/fixtures/ec2-private.xml'))
    expect(subject.run(true)).to eq([])
  end
end
