# Library App

Rails 8.1 application for managing authors, books, members, and loans in a small library.

## Prerequisites

-   Ruby `3.4.7` (see `.ruby-version`)
-   Bundler `>= 2.5`
-   Node.js `>= 18` and Yarn (for managing JS dependencies when needed)
-   SQLite 3 (default DB)

## Quick Start

```bash
git clone <repo-url>
cd library
bin/setup
bin/dev
```

`bin/setup` installs gems, prepares the database, and runs migrations. `bin/dev` starts the Rails server with Tailwind, Turbo, and esbuild via `Procfile.dev`.

### Manual Setup (if you prefer explicit steps)

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed  # optional demo data
```

## Seeding Data

The app ships with structured seeders in `db/seeds/*.rb`. Run:

```bash
bin/rails db:seed
```

Seed counts can be tweaked inside `db/seeds.rb`.

## Start the Server

Development mode with hot reloading and Tailwind watcher:

```bash
bin/dev
```

Minimal Rails server (no Procfile services):

```bash
bin/rails server
```
