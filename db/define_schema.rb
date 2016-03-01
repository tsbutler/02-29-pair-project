require_relative "./_configure"

DB.define_table("users")
DB.define_column("users", "name", "string")
DB.define_column("users", "username", "string")
DB.define_column("users", "email", "string")
DB.define_column("users", "password", "string")
DB.define_column("users", "budget", "integer")

DB.define_table("choices")
DB.define_column("users", "destination_id_1", "integer")
DB.define_column("users", "destination_id_2", "integer")
DB.define_column("users", "destination_id_3", "integer")
DB.define_column("users", "destination_id_4", "integer")
DB.define_column("users", "destination_id_5", "integer")

DB.define_table("destinations")
DB.define_column("destinations", "name", "string")
DB.define_column("destinations", "price", "decimal")