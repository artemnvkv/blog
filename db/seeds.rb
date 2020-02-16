if Rails.env == 'development'
  NUM_USERS = 100
  NUM_IPS = 50
  NUM_POSTS = 200_000

  logins = []
  NUM_USERS.times { logins << Faker::Internet.unique.user_name }

  ips = []
  NUM_IPS.times { ips << Faker::Internet.unique.public_ip_v4_address }

  title = Faker::Lorem.characters(10)

  body = Faker::Lorem.sentence(10)

  rates = (1..5).to_a
  ms_first = [0]
  ms_second = [0]

  NUM_POSTS.times do |i|
    ms_first << Benchmark.measure {
      `curl -H "CONTENT_TYPE: application/json" -s -X POST -d \
      '{"title": "#{title}", "body": "#{body}", "login": "#{logins.sample}", "ip_address": "#{ips.sample}"}' http://0.0.0.0:3000/api/v1/posts`
    }.real

    next unless rand(0..500).zero?

    rates.sample.times do
      ms_second << Benchmark.measure {
        `curl -H "CONTENT_TYPE: application/json" -s -X PUT -d \
        '{"rating": #{rates.sample}}' http://0.0.0.0:3000/api/v1/posts/#{i + 1}`
      }.real
    end
  end

  pp ms_first.reduce(:+) / ms_first.size.to_f
  pp ms_second.reduce(:+) / ms_second.size.to_f
end
