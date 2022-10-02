> :warning: **This branch includes examples for an unsupported version of Materialize (0.26.0).**

# Materialize + Redpanda + dbt Hack Day

[![Slack Badge](https://img.shields.io/badge/Slack-%23hack--day?style=flat&logo=slack&link=https://materializecommunity.slack.com/archives/C031905K62Y)](https://materializecommunity.slack.com/archives/C031905K62Y)

Welcome to the first virtual Hack Day hosted by Materialize and our good friends at Redpanda and dbt Labs! The goal of this event is to encourage knowledge-sharing between our communities (we've already learned so much just putting it together!), and give you a taste of what building streaming analytics pipelines with this stack looks like.

## What to expect

Maybe you've never used dbt. Maybe you're new to streaming. Maybe you're even new to dbt _and_ streaming. But guess what: it doesn't really matter!

* [Hack Day Agenda](https://materialize.com/resources/materialize-dbt-redpanda-virtual-hack-day/)

We'll kick things off with a quick intro to each of the projects and go over the details of the event to make sure you're all set! From there, you can **choose your own Hack Day adventure**. We are also giving you [somewhere to start](#where-to-start)!

### How does it work?

:space_invader: **Build**

Throughout the day, folks from all three projects will be available to bounce off ideas, support you with your project or just...chat. To get in touch with us, join the official [Slack channel](https://materializecommunity.slack.com/archives/C031905K62Y) or reach out in [Troubleshooting](https://github.com/MaterializeInc/mz-hack-day-2022/discussions/categories/troubleshooting)!

:palms_up_together: **Share**

At the end of the event, we encourage you to **share** your projects, experiments and learnings in [Show and tell](https://github.com/MaterializeInc/mz-hack-day-2022/discussions/categories/show-and-tell)! This can be a link to a GitHub repo with your project, a blog post, or just a plain text recap of your Hack Day...whatever feels right.

:boom: **Get out there!**

As a "Thank you!" for joining us and getting your hack on, we'd love to send you some swag! We might also reach out about promoting and showcasing your work more widely in the data community.

## Where to start

Our goal was to guarantee that everyone is able to get up and running in a reasonable amount of time, as well as find something fun to work on regardless of their level of expertise with each tool. For this reason, you can find a [sample project](/sample_project/README.md) in the repo with enough plumbing to spin up an end-to-end setup that you can play around with, extend or completely modify:

<p align="center">
<img width="650" alt="demo_overview" src="https://user-images.githubusercontent.com/23521087/151333471-98ad518d-5ac5-444e-b065-83e3aaa42748.png">
</p>

To get started, fork this repo, clone it and navigate to the `sample_project` directory:

```
git clone https://github.com/<github-username>/mz-hack-day-2022.git

cd mz-hack-day-2022/sample_project
```

### Where to go from here?

There's a lot more you can do as you ramp up! In case you need some ideas, here are a few seed challenges:

| **Tool**       | **Challenge**            |
| -------------- | ------------------------ |
| Materialize    | Replace the JSON file with a Postgres database that pushes changes to the aircraft reference data into Materialize, either through [Redpanda+Debezium or directly](https://materialize.com/docs/guides/cdc-postgres/).                       |
| Materialize    | Push data from a materialized view to a web app using [`TAIL`](https://materialize.com/docs/sql/tail/). You can use our [Node.js and Materialize guide](https://materialize.com/docs/guides/node-js/) as a reference! |
| Redpanda       | Create a producer for a new data source or adapt the existing one to use [pandaproxy](https://redpanda.com/blog/pandaproxy/) instead. |
| Redpanda       | Give [WASM transforms (beta)](https://redpanda.com/blog/data-transformation-engine-with-wasm-runtime/) a try for data pre-processing (_e.g._ cleaning, masking). |
| dbt            | Add a [sink](https://materialize.com/docs/sql/create-sink/) model that outputs the results of the `fct_flight` materialized view back to Redpanda. |
| dbt            | Incorporate macros from the [`materialize-dbt-utils`](https://hub.getdbt.com/materializeinc/materialize_dbt_utils/latest/) package into your models.                  |

## Resources

### Documentation

* [Materialize](https://materialize.com/docs/)

* [Redpanda](https://docs.redpanda.com/)

* [dbt](https://docs.getdbt.com/docs/introduction)

### Alternative data sources

| **Source**       | **Requires authentication?** | **Rate limited?** | **Link**          |
| ---------------- | :--------------------------: | :---------------: | ----------------- |
| Citi Bike NYC    |                              |                   | [Citi Bike GBFS real-time feed](http://gbfs.citibikenyc.com/gbfs/gbfs.json) |
| Network Rail UK  | :ballot_box_with_check:      |                   | [RTPPM](https://www.networkrail.co.uk/who-we-are/transparency-and-ethics/transparency/open-data-feeds/)
| Twitter          | :ballot_box_with_check:      | :ballot_box_with_check: | [Twitter API v2](https://developer.twitter.com/en/docs/twitter-api) |
| Twitch           | :ballot_box_with_check:      | :ballot_box_with_check: | [Twitch API](https://dev.twitch.tv/docs/api/) |

If you know about other cool data sources you'd like to add to the list, feel free to open an issue or a pull request with suggestions!
