require 'net/http'
require 'sinatra'
require 'json'
require 'uri'

GITHUB_ROOT = "https://api.github.com"

HEADERS = {
  'Content-Type' => 'text/json',
  'Authorization' => "token #{ENV['GITHUB_TOKEN']}"
}


# Update the Status API
def update_status(payload, status)
  sha = payload.after
  repo = payload.repository.full_name
  state, description = status.first

  # setup http post
  uri = URI.parse("#{GITHUB_ROOT}/repos/#{repo}/statuses/#{sha}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  # post to GitHub
  params = {:state => state, :description => description, :context => "spoof check"}
  http.post(uri.path, params.to_json, HEADERS)
end


# validate all commits are from the pusher
def validate(payload)
  # read all committer emails
  committers = payload.commits.map{ |c| c.author.email }.uniq

  # validate all commits are from the pusher
  if committers.count > 1
    {:failure => "Includes commits from #{committers.count} committers"}
  elsif !committers.include?(payload.pusher.email)
    {:failure => "Committer doesn't match pusher"}
  else
    {:success => "All commits match pusher"}
  end
end


# Respond to WebHook Event
post '/payload' do
  payload = JSON.parse(request.body.read, object_class: OpenStruct)

  # update status to pending until completed
  update_status(payload, :pending => "validating commits")

  # update github
  update_status(payload, validate(payload))
end
