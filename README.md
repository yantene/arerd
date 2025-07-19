# Arerd

**Arerd** is a Ruby gem that extracts Entity-Relationship (ER) information from your ActiveRecord models and generates clear, visual ER diagrams in [Mermaid](https://mermaid-js.github.io/) format.

Once integrated into your Rails project, Arerd provides a convenient Rake task (`db:erd:mermaid` or `db:erd:markdown`) that outputs a Mermaid-formatted ER diagram directly to your terminal.

You can also automate ER diagram generation in your CI pipeline by outputting the diagram in Markdown format. This ensures your ER diagram documentation is always up to date and easy to maintain.

## Installation

Add Arerd to your Rails application's Gemfile:

```ruby
gem "arerd"
```

Then install the gem:

```shell
bundle install
```

## Usage

### Generate a Mermaid ER Diagram

Run the following command to create a Mermaid ER diagram:

```shell
bin/rails db:erd:mermaid
```

This will output the diagram in Mermaid's `erDiagram` format to standard output. You can copy and paste the result into the [Mermaid Live Editor](https://mermaid.live/) or any Mermaid-compatible tool to visualize your ER diagram.

### Generate a Markdown ER Diagram

To output the ER diagram in Markdown format:

```shell
bin/rails db:erd:markdown
```

This command prints the diagram wrapped in triple backticks and tagged as `mermaid`, allowing you to preview it directly in supported Markdown editors or viewers.

### Internationalization (I18n) Support

Table and column names in diagrams are automatically translated using your Rails application's locale files. Arerd leverages Rails' I18n system to provide localized names for entities and attributes, making diagrams more accessible for international teams.

### Notes

* **All associations must specify the `inverse_of` option.**
* Associations using `has_many :through` are ignored.
* Polymorphic associations (e.g., `belongs_to :taggable, polymorphic: true`) are not supported.

### Example Output

```mermaid
erDiagram
  User["User (ユーザー)"] {
    integer id PK "Id"
    string name UK "名前 (indexed)"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  Profile["Profile (プロフィール)"] {
    integer id PK "Id"
    integer user_id FK "ユーザーID (indexed)"
    string bio "自己紹介 (nullable)"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  Post["Post (投稿)"] {
    integer id PK "Id"
    string title "タイトル"
    text body "本文"
    integer user_id FK "ユーザーID (indexed)"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  Notification["Notification (通知)"] {
    integer id PK "Id"
    integer user_id FK "ユーザーID (indexed)"
    integer sender_id FK "送信者ID (nullable, indexed)"
    string message "メッセージ"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  Follow["Follow (フォロー)"] {
    integer id PK "Id"
    integer follower_id FK "フォロワーID (indexed)"
    integer followed_id UK "フォロー対象ID (indexed)"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  Community["Community (コミュニティ)"] {
    integer id PK "Id"
    string name "名前"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }

  User ||--o{ Post : "posts / user"
  User ||--o| Profile : "profile / user"
  User ||--o{ Follow : "follows / follower"
  User ||--o{ User : "followees / followers"
  User ||--o{ Follow : "reverse_follows / followee"
  User ||--o{ User : "followers / followees"
  User ||--o{ Notification : "notifications / user"
  User |o--o{ Notification : "sent_notifications / sender"
  Community }o--o{ User : "users / communities"
```
