class CreateInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :infos do |t|
      t.integer :issueID
      t.integer :issueType

      t.timestamps
    end
  end
end
