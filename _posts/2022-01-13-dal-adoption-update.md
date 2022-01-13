---
title: Update on the adoption of the Digital Asset Links protocol
tags: [phishing,web]
---

I have repeated a measurement we did in "Phishing Attacks on Modern Android"; see my [publications](/publications/) page. In addition to the paper, you will also find the video.

We were interested in determining how ready the ecosystem is regarding the information required to build a secure app-to-web mapping. 
Given that the current standard is the [Digital Asset Links](https://developers.google.com/digital-asset-links) (DAL from now on) protocol, we set to analyze the adoption rate by querying a dataset of domain names for their related `assetlinks.json` DAL file. 

As a dataset, we considered all domain names from all mapping we extracted from the password managers we have inspected. 
Note that since they are extracted from password managers, it is very likely that these domain names host at least one page with a login form, thus making them relevant for this observation. 
In our article published in 2018, we were able to query 8,821 unique websites, but unfortunately, I did not save the complete list with all the domains, so I repeated the measurement on these.

Today (2022-01-13), I have successfully queried **5,506** unique websites for the `/.well-known/assetlinks.json` file. Namely, I have excluded all those who returned a status code other than 404 or 200. 
I found that **24%** (1,330/5,506) of them host an associated DAL file, and **23%** (1,265/5,506) specify an Android app in accordance with Google documentation. 
Four years ago, such percentages were 8% and 2%, respectively.

I am glad to see an increase, but I was hoping for more. 
I think DAL is vitally important to the Android ecosystem: not only does it allow to map the package name to websites securely, but it also provides for specifying the app signature, which is crucial for thwarting attacks and identifying malware.
