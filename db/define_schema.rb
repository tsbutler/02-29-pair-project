require_relative "./_configure"

DB.define_table("users")
DB.define_column("users", "name", "string")
DB.define_column("users", "username", "string")
DB.define_column("users", "email", "string")
DB.define_column("users", "password", "string")
DB.define_column("users", "budget", "integer")

DB.define_table("choices")
DB.define_column("choices", "user_id", "integer")
DB.define_column("choices", "destination_id", "integer")

DB.define_table("destinations")
DB.define_column("destinations", "airport_code", "string")
DB.define_column("destinations", "name", "string")