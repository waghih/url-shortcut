# URL Shortcut

## Overview

This project is a URL shortener application built with Ruby on Rails. It allows users to shorten URLs, track click statistics, and view geolocation data. The application uses PostgreSQL for data storage, Sidekiq for background job, and Redis for sidekiq job processing.

DEMO: https://url-shortcut.onrender.com

## Technology Stack

- **Ruby**: 3.0.1
- **Rails**: 7.1.3
- **PostgreSQL**: 13.x or later
- **Sidekiq**: For background jobs
- **Redis**: For Sidekiq job processing

## Installation

1. **Clone the repository:**

    ```bash
    git clone git@github.com:waghih/url-shortcut.git
    cd url-shortcut
    ```

2. **Install dependencies:**

    ```bash
    bundle install
    ```

3. **Set up the database:**

    ```bash
    rails db:setup
    ```

4. **Set up Redis and Sidekiq:**

    Make sure you have Redis installed and running. You can start Redis with:

    ```bash
    redis-server
    ```

    Start Sidekiq with:

    ```bash
    bundle exec sidekiq
    ```

5. **Run the application:**

    Since we are using tailwindcss, we will need to use different command to start the application and watch for tailwind changes at the same time

    ```bash
    ./bin/dev
    ```

    Or can start the application by running the command separately

    ```bash
    rails server
    ```

    open second terminal and run:

    ```bash
    rails tailwindcss:watch
    ```

## Running Tests

To check code quality locally, run:

```bash
rails qa
