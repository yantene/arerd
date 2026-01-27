# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Arerd is a Ruby gem that generates Entity-Relationship (ER) diagrams from ActiveRecord models in Mermaid format. It provides rake tasks (`db:erd:mermaid` and `db:erd:markdown`) that can be used in Rails applications.

## Common Commands

### Development Commands
- `bundle exec rake test` - Run all tests (Minitest)
- `bundle exec rake standard` - Run StandardRB linter
- `bundle exec rake standard:fix` - Auto-fix StandardRB violations
- `bundle exec rake` - Run both tests and linter (default task)

### Testing in a Rails Application
To test the gem in a Rails app during development:
- `bin/rails db:erd:mermaid` - Generate Mermaid diagram to stdout
- `bin/rails db:erd:markdown` - Generate Markdown-wrapped diagram to stdout

### Running a Single Test
```bash
bundle exec ruby -Ilib:test test/test_association.rb
```

## Code Architecture

### Core Components

#### 1. **Association Model** ([lib/arerd/association.rb](lib/arerd/association.rb))
The heart of the gem. Represents a bidirectional relationship between two ActiveRecord models. Key characteristics:
- Stores left/right model pairs with their association names and multiplicities
- `build` class method converts ActiveRecord reflection objects into Association instances
- Filters out unsupported association types (`:through`, polymorphic)
- **Important**: Only creates one Association object per bidirectional relationship by comparing model names lexicographically (line 85) to avoid duplicates in has_and_belongs_to_many

#### 2. **ERD Generator** ([lib/arerd/erd_generator.rb](lib/arerd/erd_generator.rb))
Orchestrates the diagram generation:
- `collect_models_and_associations`: Eager loads Rails app, collects all ApplicationRecord descendants, builds Association objects
- `generate_mermaid`/`generate_markdown`: Renders ERB templates with collected data
- Templates use Rails I18n (`model_name.human`, `human_attribute_name`) for internationalization

#### 3. **Templates** ([lib/arerd/templates/](lib/arerd/templates/))
- `erd.mmd.erb`: Generates Mermaid erDiagram syntax
  - Introspects database for index information to mark FK/UK columns
  - Maps association multiplicities to Mermaid relationship symbols (||, |o, }o, o{)
- `erd.md.erb`: Wraps Mermaid output in Markdown code fence

#### 4. **Railtie Integration** ([lib/arerd/railtie.rb](lib/arerd/railtie.rb))
Minimal Rails integration that loads rake tasks when Rails is present.

### Association Building Logic

The `Association.build` method handles different ActiveRecord association types:
- **has_many/has_one**: Creates Association from the "owning" side, requires `inverse_of`
- **has_and_belongs_to_many**: Creates only one Association per pair (avoids duplicates via name comparison)
- **belongs_to**: Only validates `inverse_of` presence, doesn't create Association (parent association handles it)
- **Filtered out**: `:through` associations, polymorphic associations

### Test Structure

Tests use Minitest with an in-memory SQLite database:
- [test/test_helper.rb](test/test_helper.rb): Sets up ActiveRecord connection and I18n
- [test/support/schema.rb](test/support/schema.rb): Defines test database schema
- [test/support/models.rb](test/support/models.rb): Defines test ActiveRecord models
- All test models must include `inverse_of` option per gem requirements

## Important Constraints

1. **All associations must specify `inverse_of` option** - The gem warns and skips associations without it
2. **has_many :through associations are ignored** - They're considered "virtual" associations
3. **Polymorphic associations are not supported** - The gem warns and skips them
4. **ApplicationRecord descendants only** - The gem specifically looks for `ApplicationRecord.descendants`

## StandardRB Linting

This project uses StandardRB for code style. Configuration is minimal (see [.standard.yml](.standard.yml)). Follow StandardRB conventions for all code changes.
