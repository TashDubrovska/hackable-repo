# Why leaking your private `ssh` GitHub key is dangerous? 

When we consider security we often first and furthermost think about what our users interact with. APIs, forms, iframes, redirects, compromised third-party dependancies – there is a lot to consider. However, keeping our codebase secure is equally as important.

This repo is created to showcase the dangers of leaking private `ssh` keys linked to a GitHub account. In real world (especially if your projects are private) it might be a bit more tricky to gain access, but with perseverance nothing is impossible!

In order to pose as somebody else for specific repository we have two prerequisites which can be often obtained from environment variables of the hosted app:
- GitHub repo address;
- private `ssh` key of user with commit privileges;

From that point onwards it is an open season .

## GitHub API is awesome
Using [GitHub API]() we can do a lot of things. It often stands as an invisible force behind automation in our CIs, but, as we all well know, with great power comes great responsibility.

### Zeroing in on a victim
#### Finding out username 
Upon learning address of the repo I wanted to target my first goal was to obtain a list of user who made commits to it. As it turns out doing this is incredibly simple. Just run a [query for contributors](https://api.github.com/repos/TashDubrovska/hackable-repo/stats/contributors) (`repos/<USERNAME>/<REPO NAME>/stats/contributors`) and you will receive something very similar to the data shown below for each contribution:
```json
"author": {
    "login": "ThrowawaySecurity",
    "id": XXXXXXX,
    "node_id": "...",
    "avatar_url": "...",
    "gravatar_id": "",
    "url": "...",
    "html_url": "...",
    "followers_url": "...",
    "following_url": "...",
    "gists_url": "...",
    "starred_url": "...",
    "subscriptions_url": "...",
    "organizations_url": "...",
    "repos_url": "...",
    "events_url": "...",
    "received_events_url": "...",
    "type": "User",
    "site_admin": false
}
```

#### Getting public `ssh` key to go with the leaked private
Next I needed to find any public keys linked to this account which again was a trivial task. [New query for user keys](https://api.github.com/users/ThrowawaySecurity/keys) (`/users/<USER>/keys`) pretty much done all of the heavy lifting for me.
```json
[
  {
    "id": XXXXXXX,
    "key": "..."
  }
]
```

Given how well API responses are formatted finding a pair for the leaked key is a question of a quick script which will fully automate the process.

#### Making sure impersonation is complete
In order to complete my disguise I needed two more pieces of information:
- username;
- email;

First one of course was obtained in the previous step and second could be gathered by, you guessed it, yet another [GitHub API query for recent commits](https://api.github.com/users/ThrowawaySecurity/events) (`/users/<USER>/events`).
```json
"commits": [
    {
        "sha": "...",
        "author": {
            "email": "my-email@me.io",
            "name": "ThrowawaySecurity"
        },
        "message": "Update README.md",
        "distinct": true,
        "url": "..."
    }
]
```

Now that my data gathering was complete only the last step remained: pretending that I am somebody else to commit 😉 a perfect crime.

## Scripting my way into strangers' house
In order to make my life a bit easier I created a small script which can be found in this repository and took care of everything which needed doing:
- setting `ssh` key pair;
- adding them to `ssh` keychain;
- setting up new username and email;

And the rest? The rest is in the commit history, but imagine the possibilities. With this setup I am able to not only compromise this repo, but through the trusty `events` API, find out where else my victim can commit, continuing my trail of destruction.

## Lessons learned
So what can we learn from this little adventure?
- keep your repositories private;
- keep your email private;
- do not give deployment accounts and bots write access to your repo;
- remove `ssh` keys from the list of environment variables post deployment;
- ...or do not add them to environment variables at all unless absolutely necessary;
- treat GitHub secrets with the same care as any other secrets;
