# Moves the credentials of the orchestra / person member users to their Member
# and removes those users. Users that have roles are kept, they are reported.
class MoveMemberLevelUsersToMembers < ActiveRecord::Migration[7.2]
  class MigrationUser < ActiveRecord::Base
    self.table_name = "users"
  end

  class MigrationMember < ActiveRecord::Base
    self.table_name = "members"
  end

  class MigrationPasskey < ActiveRecord::Base
    self.table_name = "passkeys"
  end

  def up
    MigrationUser.where(entity_class: %w[Orchestra PersonMember]).find_each do |user|
      member = MigrationMember.find_by(member_entity_type: user.entity_class, member_entity_id: user.entity_id)

      if member.nil?
        say "user #{user.id}: #{user.entity_class} #{user.entity_id} has no member, skipped"
        next
      end

      if select_value("select count(*) from users_roles where user_id = #{user.id.to_i}").to_i.positive?
        say "user #{user.id} (mglnr #{member.mglnr}) has roles, skipped"
        next
      end

      if member.encrypted_password.present?
        say "member #{member.mglnr} already has a password, user #{user.id} skipped"
        next
      end

      member.update_columns(encrypted_password: user.encrypted_password,
                            webauthn_id: user.webauthn_id.presence,
                            sign_in_count: user.sign_in_count,
                            current_sign_in_at: user.current_sign_in_at,
                            last_sign_in_at: user.last_sign_in_at,
                            current_sign_in_ip: user.current_sign_in_ip,
                            last_sign_in_ip: user.last_sign_in_ip,
                            remember_created_at: user.remember_created_at)

      MigrationPasskey.where(owner_type: "User", owner_id: user.id).update_all(owner_type: "Member", owner_id: member.id)

      user.destroy
      say "user #{user.id} -> member #{member.mglnr}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
