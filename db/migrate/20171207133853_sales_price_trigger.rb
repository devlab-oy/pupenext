class SalesPriceTrigger < ActiveRecord::Migration
  def up
    sql = <<-SQL
      create trigger changelog_tuote_myyntihinta after update on tuote
      for each row
      begin
        if NEW.myyntihinta <> OLD.myyntihinta and (select myyntihinnan_muutoksien_logitus from yhtion_parametrit where yhtio = NEW.yhtio) = 'x'
        then
          INSERT INTO changelog SET
          `yhtio` = NEW.yhtio,
          `table` = NEW.tuoteno,
          `key` = NEW.tunnus,
          `field` = 'myyntihinta',
          `value_str` = NEW.myyntihinta,
          `laatija` = NEW.muuttaja,
          `luontiaika` = now();
        end if;
      end;
    SQL

    execute sql
  end

  def down
    execute "drop trigger changelog_tuote_myyntihinta"
  end
end
