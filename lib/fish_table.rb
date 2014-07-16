class FishTable

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(fish_name, fish_wiki, user_id)
  insert_fish_sql = <<-SQL
      INSERT INTO fish (fish_name, fish_wiki, user_id)
      VALUES ('#{fish_name}', '#{fish_wiki}', #{user_id})
      RETURNING id
  SQL

  @database_connection.sql(insert_fish_sql).first["id"]
end

def find(id)
  find_sql = <<-SQL
      SELECT * FROM fish
      WHERE id = #{id}
  SQL

  @database_connection.sql(find_sql).first
end

def find_by(fish_name)
  find_by_sql = <<-SQL
      SELECT * FROM fish
      WHERE fish_name = '#{fish_name}'
  SQL

  @database_connection.sql(find_by_sql).first
end


def delete(id)
  @database_connection.sql("DELETE FROM fish where id = #{id}")
end

def select_all
  select_sql = "select * from fish"
  @database_connection.sql(select_sql)
end


end