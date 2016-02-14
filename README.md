# Validate A GitHub Pusher

## Create A Server
Use the [server example](server.rb) as a guide on how to validate the JSON payload on [Push events](https://developer.github.com/v3/activity/events/types/#pushevent).

```ruby
# validate all commits are from the pusher
def validate(payload)
  # read all committer emails
  committers = payload.commits.map{ |c| c.author.email }.uniq

  # validate all commits are from the pusher
  if committers.count > 1
    :failure => "Includes commits from #{committers.count} committers"]
  elsif !committers.include?(payload.pusher.email)
    :failure => "Committer doesn't match pusher"
  else
    :success => "All commits match pusher"
  end
end
```

Add the validation to your CI server or any stand-alone webserver that responds to [GitHub's WebHook events](https://developer.github.com/webhooks/).


## Validate the WebHook Payload
The [JSON Payload](https://gist.github.com/gjtorikian/5171861) will contain the [Git Author](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L9) and the [Git Commiter](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L14) for each files modified. These values come from the `.gitconfig` on the user's computer.

![](https://cloud.githubusercontent.com/assets/35968/12996038/14af75a0-d0e1-11e5-9640-9191f03dd9a0.png)

The payload also contains the [Pusher's Info](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L114) who is the authenticated GitHub user that has pushed up the code.

![](https://cloud.githubusercontent.com/assets/35968/12996039/14b103b6-d0e1-11e5-8aa5-eabd6ff6d69f.png)

## Configure the WebHook
[Create a Webhook](https://developer.github.com/webhooks/) and watch for the [Push Event](https://developer.github.com/v3/activity/events/types/#pushevent). This event is triggered when you push from the command-line or commit a change through the Web UI.

![](https://cloud.githubusercontent.com/assets/35968/13031597/e8aed22c-d287-11e5-9f98-5b9c5d960166.png)


## Protect the Master Branch
To prevent merges until identity checks are passed, enable [Protected Branches](https://help.github.com/articles/configuring-protected-branches/) and [Required Status Checks](https://help.github.com/articles/enabling-required-status-checks/), then have your CI server run checks against the JSON payload delivered from the Webhook.

![](https://cloud.githubusercontent.com/assets/35968/12996113/9eb5fd00-d0e1-11e5-8be1-b458d359e8ef.png)
