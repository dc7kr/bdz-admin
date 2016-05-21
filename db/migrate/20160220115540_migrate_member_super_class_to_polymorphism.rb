class MigrateMemberSuperClassToPolymorphism < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE members set member_entity_type=subtype
    SQL
    Orchestra.all.each do |o|
      m = o.member
      m.member_entity_id=o.id
      m.save
    end
    PersonMember.all.each do |p|
      m = p.member
      m.member_entity_id=p.id
      m.save
    end
  end

  def down
  end
end
