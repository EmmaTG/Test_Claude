## Title
Enable migration scripts and proto buf generation

## Acceptance criteria
1. The microservice can utiliize migrations scripts to create and update the database
2. The microservice utililzes protobuf and protobuf generation for its endpoints

## Tasks
1. Create a migration script to add a table called "Table" to the postgres data base
2. Enable running the migration scripts on start of the microservice
3. Enable proto buf generation for the golang microservice