# Style

What `bin/rubocop` cannot check. Apply it in one pass at the end of a task, then make
`bin/rubocop`, `bin/rake file_length` and `bin/rails test` pass.

## Everywhere

- Shorter wins: names, comments, commit messages, the words on a page. Of two real English
  words that fit, take the shorter: `Chat`, not `Conversation`.
- American English, everywhere: `color`, `behavior`. An acronym is capitals: ZIP, API, PIN.

## Ruby

- Never add a method nothing calls; remove one whose last caller goes. No `rescue` for an
  error that has never happened.
- Call methods on yourself, on what you were handed and on what you hold, never on what those
  hand back: `provider.import_visits`, not `provider.import_visits(provider.authentication.upcoming)`.
- Ask a question once: a condition checked in one place is not checked again, reversed, in the
  next. Lift it above both and let what sits underneath assume the answer.
- Let the structure hold the rule: a model that refuses bad input beats every caller
  remembering to check.
- A method named like a query (`find_for`, `matching`) never writes. Where both happen, write
  the lookup and the update in the open.
- Behavior belongs to the object that owns the data. No service objects, no `call` method:
  `contact.generate_pin`, not `PinGenerator.new(contact).call`.
- A class that knows a third party's shapes is named for it: `Contact::Twilio`.
- No metaprogramming: no `send`, `public_send`, `define_method` or `instance_variable_get`.
- No type signatures: no RBS, Sorbet or `sig/`.
- No code file over 120 lines (`bin/rake file_length`). Over the limit, extract a concern or a
  second controller named for what it owns, never a class named for a verb.
- At most 50 Ruby files in a folder. Over it, split by what the files are, not where they went.
- Name every keyword a method takes. Never accept `**attributes` only to pass the bag on.
- Publish as little as possible: a method only the class calls is private, and two public
  methods a caller always uses together are one method the class is missing.

### Comments

- One line before every public class, module, constant and method, saying what it is for. None
  on private methods. Inside a body, only *why*.
- Plain statements: no metaphor, no history (`used to`, `no longer`, `now that`), no `see X`.
- What one line cannot hold goes in the commit message.

### Layout

- At most one `return`, and only as the first line: the case refused before any work. Past
  it, branch with `if`/`elsif`, and write `if @record.save ... else ... end`.
- A one-expression method is one line where it fits: `def to_s = email`. Never where the body
  assigns, takes a block, or ends in a modifier `if`/`unless`.
- Omit parentheses on a call's arguments, but keep them on a call inside a condition:
  `if @contact.update(params)`, `redirect_to root_path if flash.any?`.
- Prefer keyword arguments past two parameters, and `Hash#fetch` with a default.

## Rails

- Fat model, skinny controller; the seven actions only. A new verb is a new resource
  (`resource :verification`), never a custom action.
- Strong parameters, scopes for queries, no query logic in a controller or view, no
  `helper_method`.
- Slow or external work is an Active Job declared with `performs`.
- Every endpoint assumes Turbo: `status: :see_other` after a non-GET, `allow_other_host: true`
  to leave the app.
- A flash too long for the redirect's line is set first (`flash.notice = ...`), then the
  redirect follows whole.
- Admin pages are recourse's. Override only what recourse cannot do (`recourse_relation`, an
  action of our own), and let it do the rest.

### Data

- PostgreSQL only. Constraints in the database and validations in the model, together.
- Personal data is encrypted: phone, email, surname. A first name is not. A queried or unique
  encrypted column is `deterministic`, and an encrypted email also `downcase: true`.
- A plaintext email column is `citext`. A phone is ten digits, normalized by `Phonable`.
- Columns in this order: `type`, required enums, other required columns, required foreign keys,
  counter caches, indexed columns, the rest, timestamps last.
- A `belongs_to` has its `has_many`, with `dependent: :destroy` (or `:delete_all` when nothing
  runs per row).
- An enum is a Postgres enum type. A timestamp whose presence means a state gets a stored
  virtual boolean beside it: `verified_at` and `verified`.
- A migration is reversible (`change`, with `up_only` for one-way steps) and never edited once
  it has run anywhere but here. No migration tests.
- Never Arel. Ruby before SQL; SQL fragments where Ruby cannot say it.
- Eager-load every association a page names, and select only the columns a query displays.
- Before switching branches, roll back the migrations this branch added, and never commit a
  `db/schema.rb` dumped off another branch's migrations.

### Views

- No local variables and no comments in ERB, except a partial's `locals:` line.
- A partial declares strict locals and never reads instance variables.
- A blank line around every block-level call (`content_for`, `render`) in a template.

## Tests

- 100% line coverage, and no test that could be deleted with coverage holding.
- Test our own code through its public interface. Never test a library: not Rails, not
  recourse, not a validation.
- Names state the outcome; fixtures are minimal.

## Git

- One prompt, one commit: imperative subject that summarizes it, the why in the body.
- No trailers naming who wrote it. No merge commits: rebase.
