# Boards API

## About

This is a demo API built with Rails 5, representing a Trello-like application.

## Models

Board - Has many columns.

Column - Has many tasks. Belongs to a board. Has an unique position within a board. A column maybe rearranged within a board.

Task - Has many comments. Belongs to a column.. Has an unique position within a column. A task maybe rearranged within a column.

Comment - Belongs to a task.

## Installation

Postgres is required.

Clone this repository.

CD into the directory.

Ensure that Postgres is running.

Run the following commands:

```
bundle
rails db:create
rails db:migrate
```

To run the app locally, within the directory:

`rails s`

The host will be `http://localhost:3000`

To run tests:

`rspec`

## Authorization

An authorization bearer token within the http request headers is required for requests to all endpoints. Since this is a demo, here is the token:

> ehzLoAaX7hVUxJ2D3vLkxQ