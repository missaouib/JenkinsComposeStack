### Welcome & Introduction

Hey everyone! Thanks for joining today’s Brownbag Session! 🍽️

Today, I’m diving into something I’ve been working on recently: a fully containerized, automated Jenkins CI/CD setup.

Now, I can already hear some of you thinking, “Jenkins... again?” But hear me out — this isn’t your typical Jenkins
setup. No more hair-pulling, no more endless configuration woes. This time, it’s lean, mean, and ready to deploy without
the usual headaches. 🙌

By the end of this session, you’ll either be totally on board with this new Jenkins magic, or you’ll have a million
questions (which is totally fine!). Either way, I’ll address everything in the Feedback and Discussion section. So sit
tight, grab your coffee (or tea, or whatever fuels your brain), and let’s dive in!

---

### Project Overview

Okay, let’s start with the basics. This setup is like your favorite takeout order: quick, reliable, and scalable.
Here’s what I’m working with:

- Built once, deployed anytime – Spin up a new Jenkins instance as easily as you would reorder pizza on a Friday night.
  🍕
- Lightweight & Stateless – Jenkins runs in a container that’s as clean as your code should be. Think of it like a spa
  day for Jenkins – it’s refreshed every time!
- Automated & Self-testing – This isn’t a ‘pray and hope it works’ setup. It tests itself to make sure Jenkins is
  functional before running anything!
- Scalable & Modular – Like a good Lego set, you can add pieces as needed. DinD, dynamic agents – it’s like Jenkins, but
  on steroids (the healthy, non-bad-for-you kind).

---

### Key Components Breakdown

Now let’s get into the meat of the setup. Grab your coffee, and here’s where the fun begins:

1. **Jenkins Controller**

   The brain of the operation! This runs in a Docker container with the bare minimum setup. It’s configured using
   Jenkins Configuration as Code (CASC). No more clicking through endless GUI menus — I’m coding this bad boy into
   existence. And because I’m fancy like that, it’s stateless. The only state it’s interested in is the one where it’s
   running smoothly. No need to worry about Docker CLI commands in here; that’s for the agents to handle.

2. **Docker-in-Docker (DinD)**

   I know, I know. Docker running in Docker sounds like inception-level complexity, but trust me, it’s like having a
   Dockerception for all your build processes.

   While this setup adds some complexity, it also brings a major security benefit. Without DinD, I'd be sharing the
   host Docker socket, which opens up a lot of potential security risks. But with DinD, I'm keeping things tight and
   secure by isolating the Jenkins agents from the host system. This isolation means the agents have no direct access to
   the host Docker socket, which not only keeps the agents safe but also protects the Jenkins controller from rogue
   agent issues.

   The Jenkins agents communicate with the DinD service, which runs Docker commands to build images etc. And just so you
   know, they connect to a private registry — no public registry for us. We’re too cool for that!

3. **Jenkins Agents**

   These are the true workhorses of the setup. The agents spin up inside the DinD environment, ready to execute your
   builds — they’re like those overachieving friends who do everything while you sip your coffee ☕.

   The agents are created dynamically and automatically based on workload or pipeline requirements. When there’s a heavy
   load or more pipelines running, new agents are spun up to handle the extra work. It’s like having an unlimited number
   of extra tables at a restaurant, but of course, they’re still limited by the available hardware.

   These agents scale on demand, so you only get as many as you need when you need them. No more, no less. It’s the
   perfect balance of flexibility and efficiency!

4. **Private Docker Registry**

   This is where I keep my agent images, build artifacts, and anything I want to keep in-house. It’s like my own
   personal vault of awesomeness. Plus, I’ve got health checks in place to make sure it’s always available. Nothing’s
   worse than needing an image and finding out my registry’s down. #SadFace

5. **Sanity Check Pipeline**

   Ah, the MVP of this setup — the Sanity Check Pipeline. Imagine if Jenkins had a bouncer at the door, checking your
   ID before letting you in. That’s what this pipeline does:

    - Ensures we don’t run builds on the master node — we’re not reckless.
    - Verifies the workspace is ready to roll, like checking your suitcase before a flight.
    - Confirms all plugins are installed as specified. We’re not here for surprises.
    - Runs parallel jobs to test Jenkins’ multitasking skills. And yes, Jenkins can multitask better than I can.
    - Ensures Docker is installed and accessible. After all, it’s hard to run Docker without Docker, right?

---

### CI/CD Flow Walkthrough

Now, let’s take a quick stroll through the CI/CD flow — and no, it’s not as complicated as it sounds. This setup runs
on GitHub Actions and ensures Jenkins gets deployed without any weird, manual configurations.
Once Jenkins is spun up, we execute the sanity check pipeline, which checks the whole system before we let it near any
production builds. Think of it as Jenkins’ first date — we’re making sure it’s good before it meets the family!

---

### Demo

And now, the moment we’ve all been waiting for — the demo! We’ll spin up the setup, run a quick pipeline, and you’ll
see this beauty in action. It’s like watching a perfectly synchronized dance — except with Docker containers and no
actual dancing. Unless you count me dancing behind the scenes with excitement.

---

### Feedback and Discussion

Okay, now that I’ve shown off all the cool stuff, it’s your turn! I need your feedback. Is the setup working in the
direction we need? Anything that’s confusing or needs tweaking? Feel free to ask questions anytime, but I’ll focus on
feedback here at the end. Your input helps shape the project’s future. So, let’s make it awesome together!

---

### Conclusion

To wrap up, this setup is like a lean, mean, Jenkins machine:

- It works right out of the box.
- It’s automated, self-testing, and self-healing.
- It scales like a pro.
  And most importantly, it ensures Jenkins is always production-ready, so I don’t waste time fixing things that
  should’ve been caught earlier.
  I’m excited to hear your thoughts, and as always, if you have any questions later, feel free to reach out. I’m happy
  to chat about containers, Jenkins, or anything else that tickles your fancy. Thanks for attending — and now, let’s
  hear your feedback!
