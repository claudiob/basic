class CreateAgentsContactsAndChats < ActiveRecord::Migration[8.2]
  def change
    enable_extension 'citext'
    create_enum :omen_status, Omen::Stated::STATUSES

    create_table :agents do |t|
      t.citext :email, null: false, index: { unique: true }
      t.timestamps
    end

    create_table :contacts do |t|
      t.string :phone, null: false, index: { unique: true }
      t.string :email
      t.string :name
      t.string :surname
      t.string :pin, limit: 6
      t.timestamps
    end

    create_table :omen_readings do |t|
      t.string :type, index: true
      t.enum :status, enum_type: :omen_status, default: Omen::Stated::STATUSES.first, null: false
      t.integer :input_usage, default: 0, null: false
      t.integer :output_usage, default: 0, null: false
      t.references :agent, null: false, foreign_key: true
      t.integer :questions_count, default: 0, null: false
      t.timestamps
    end

    create_table :omen_questions do |t|
      t.jsonb :content, default: [], null: false
      t.references :reading, null: false, foreign_key: { to_table: :omen_readings }
      t.timestamps
    end

    create_table :omen_answers do |t|
      t.jsonb :content, default: [], null: false
      t.json :result, default: [], null: false
      t.jsonb :provenance, default: {}, null: false
      t.integer :input_usage, default: 0, null: false
      t.integer :output_usage, default: 0, null: false
      t.references :question, null: false, index: { unique: true },
        foreign_key: { to_table: :omen_questions }
      t.string :stop_reason
      t.string :error
      t.timestamps
    end
  end
end
