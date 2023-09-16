Mix.Task.run "ecto.dump", ["--quiet"]
File.cp("./priv/repo/structure.sql", "../geolocation_service_importer/priv/import_repo/")
Mix.shell().info("Populated structure.sql into #{Path.expand("../geolocation_service_importer/priv/import_repo/", __DIR__)}")
