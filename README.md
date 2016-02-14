# Validate A GitHub Pusher

[Create a Webhook](https://developer.github.com/webhooks/) and watch for the [Push Event](https://developer.github.com/v3/activity/events/types/#pushevent). This event is triggered when you push from the command-line or commit a change through the Web UI.

![](https://cloud.githubusercontent.com/assets/35968/12995955/6006423c-d0e0-11e5-9902-9ac7caa41371.png)

The [JSON Payload](https://gist.github.com/gjtorikian/5171861) will contain the [Git Author](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L9) and the [Git Commiter](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L14) for each files modified. These values come from the `.gitconfig` on the user's computer.

![](https://cloud.githubusercontent.com/assets/35968/12996038/14af75a0-d0e1-11e5-9640-9191f03dd9a0.png)

The payload also contains the [Pusher's Info](https://gist.github.com/gjtorikian/5171861#file-sample_payload-json-L114) who is the authenticated GitHub user that has pushed up the code.

![](https://cloud.githubusercontent.com/assets/35968/12996039/14b103b6-d0e1-11e5-8aa5-eabd6ff6d69f.png)

To prevent merges until identity checks are passed, enable [Protected Branches](https://help.github.com/articles/configuring-protected-branches/) and [Required Status Checks](https://help.github.com/articles/enabling-required-status-checks/), then have your CI server run checks against the JSON payload delivered from the Webhook.

![](https://cloud.githubusercontent.com/assets/35968/12996113/9eb5fd00-d0e1-11e5-8be1-b458d359e8ef.png)
