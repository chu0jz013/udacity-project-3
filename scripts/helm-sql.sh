#!/bin/bash

# Set a fixed PostgreSQL password
POSTGRES_PASSWORD="YourFixedPassword"

# Add the Bitnami repo and update
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install PostgreSQL with a fixed password
helm install prj3 bitnami/postgresql \
  --set global.postgresql.postgresqlPassword="$POSTGRES_PASSWORD" \
  --set primary.persistence.enabled=false || {
  echo "Helm install failed"
  exit 1
}

POSTGRESQL=prj3-postgresql

# No need to fetch the password from the secret since we set it manually
POSTGRES_PASSWORD=$(kubectl get secret prj3-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql --timeout=60s

# Port forward to access the PostgreSQL service
kubectl port-forward svc/prj3-postgresql 5432:5432 &
# kubectl port-forward svc/"$POSTGRESQL" 5432:5432 &

# Execute SQL files
PGPASSWORD="$POSTGRES_PASSWORD" psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/1_create_tables.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/2_seed_users.sql
PGPASSWORD="$POSTGRES_PASSWORD" psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/3_seed_tokens.sql

# POSTGRES_PASSWORD=$(kubectl get secret prj3-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
# PGPASSWORD=vuVFDQEZfh psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/1_create_tables.sql
# PGPASSWORD=vuVFDQEZfh psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/2_seed_users.sql 
# PGPASSWORD=vuVFDQEZfh psql -U postgres -d postgres -h 127.0.0.1 -a -f ./db/3_seed_tokens.sql